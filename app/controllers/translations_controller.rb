class TranslationsController < ApplicationController
  before_action :set_translation, only: [:update, :destroy]
  before_action :authorize_translation, only: [:index, :create]

  def index
    @q = Translation.ransack(params[:q])
    @locale = I18n.default_locale
    @q.locale_eq = @locale
    @q.sorts = "key desc" if @q.sorts.empty?
    all = all_translations(
      [],
      I18n.t(".", locale: @locale),
      translations_to_hash(@q.result),
      @q,
      local: @locale
    )
    all.reverse! if @q.sorts.find { |sort| sort.name == "key" }&.dir&.==("asc")
    @translations = Kaminari.paginate_array(all).page(params[:page])
  end

  def create
    t_params = translation_params
    @translation = Translation.find_or_initialize_by(locale: t_params[:locale], key: t_params[:key])
    @translation.value = t_params[:value]
    if @translation.save
      I18n.backend.reload!
      render :show, status: :created
    else
      render :show, status: :unprocessable_entity
    end
  end

  def update
    if @translation.update(value: translation_params[:value])
      I18n.backend.reload!
      render :show, status: :ok
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    if @translation.destroy
      I18n.backend.reload!
      @translation = Translation.new(
        locale: @translation.locale,
        key: @translation.key,
        value: I18n.t(@translation.key, locale: @translation.locale)
      )
      render :show, status: :ok
    else
      render :show, status: :unprocessable_entity
    end
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
