class TranslationsController < ApplicationController
  before_action :set_translation, only: [:update, :destroy]
  before_action :authorize_translation, only: [:index, :create]

  def index
    @q = Translation.ransack(params[:q])
    @locale = I18n.default_locale
    @q.locale_eq = @locale
    all = all_translations(
      [],
      I18n.t(".", locale: @locale),
      translations_to_hash(@q.result),
      @q,
      local: @locale)
    @translations = Kaminari.paginate_array(all).page(params[:page])
  end

  def create
    t_params = translation_params
    @translation = Translation.find_or_initialize_by(locale: t_params[:locale], key: t_params[:key])
    @translation.value = t_params[:value]
    @translation.save
    I18n.backend.reload!
  end

  def update
    @translation.update(value: translation_params[:value])
    I18n.backend.reload!
  end

  def destroy
    @translation.destroy
    I18n.backend.reload!
  end

  private def set_translation
    @translation = Translation.find(params[:id])
    authorize @translation
  end

  private def authorize_translation
    authorize Translation
  end

  private def translation_params
    params.require(:translation).permit(:locale, :key, :value)
  end

  private def translations_to_hash(list)
    list.index_by(&:key)
  end

  private def all_translations(key, value, db, query, local: I18n.default_locale)
    case value
    when String
      full_key = key.join(".")

      return if query.key_matches && !full_key.include?(query.key_matches)
      return if query.value_matches && !value.include?(query.value_matches)

      db[full_key] || Translation.new(
        locale: local,
        key: full_key,
        value: value
      )
    when Hash
      value.each_key.sort.map do |c_key|
        all_translations(key + [c_key], value[c_key], db, query, local: local)
      end.compact.flatten
    end
  end
end
