class TranslationsController < ApplicationController
  before_action :set_locale
  before_action :set_translation, only: [:show, :update, :destroy]
  before_action :authorize_translation, only: [:index, :create]

  def index
    @translations = all_translations([], I18n.t('.', locale: @locale),
                                      translations_to_hash(Translation.locale(@locale)))

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

  private
    def set_locale
      @locale = I18n.default_locale
    end

    def set_translation
      @translation = Translation.find(params[:id])
      authorize @translation
    end

    def authorize_translation
      authorize Translation
    end

    def translation_params
      params.require(:translation).permit(:locale, :key, :value)
    end

    def translations_to_hash(list)
      list.to_h do |e|
        [e.key, e]
      end
    end

    def all_translations(key, value, db)
      case value
      when String
        full_key = key.join('.')
        db[full_key] || Translation.new(
          locale: @locale,
          key: full_key,
          value: value
        )
      when Hash
        value.each_key.sort.map do |c_key|
          all_translations(key + [c_key], value[c_key], db)
        end.compact.flatten
      else
        # nothing
        nil
      end
    end
end
