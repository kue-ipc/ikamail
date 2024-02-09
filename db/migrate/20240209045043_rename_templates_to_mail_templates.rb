class RenameTemplatesToMailTemplates < ActiveRecord::Migration[7.0]
  def change
    rename_table :templates, :mail_templates
    rename_column :bulk_mails, :template_id, :mail_template_id
  end
end
