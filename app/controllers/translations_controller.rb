class TranslationsController < ApplicationController
  before_action :set_locale
  before_action :set_translation, only: [:show, :update, :destroy]
  before_action :authorize_translation, only: [:index, :create]

  def index
    @translations = all_translations([], I18n.t('.', locale: @locale),
                                      translations_to_hash(Translation.locale(@locale)))

  end

  def show
  end

  def create
    Translation.create(translation_params)
  end

  def update
    @translation.update(translation_params)
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
      params.require(:i18n_backend_active_record_translation).permit(:locale, :key, :value)
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
        value.map do |c_key, c_value|
          all_translations(key + [c_key], c_value, db)
        end.compact.flatten
      else
        # nothing
        nil
      end
    end
end
