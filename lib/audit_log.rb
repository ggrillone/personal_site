##
# A generic module for creating log records
# in the database
module AuditLog
  # @params resource The resource rails model to save the log to.
  # @params admin_user_id The id of the current admin user performing the action.
  # @params request_obj The entire request object sent from the controller.
  # @params params The params passed into the request.
  # @params blacklist_file The .yml file which contains
  # list of attributes that should not be saved in the log.
  # It is expected that all blacklist files are saved under
  # the config/blacklists directory.
  def self.create(resource_model, admin_user_id, request_obj, params, blacklist_file, original_attrs, new_attrs)
    audit_log_data = self.build_object(admin_user_id, request_obj, params, blacklist_file, original_attrs, new_attrs)
    resource_model.create(audit_log_data)
  end

  def self.cleanse(blacklist_file, vals = {})
    blacklist = self.get_blacklist(blacklist_file)
    cleansed_params = {}

    vals.keys.each do |key|
      cleansed_params[key] = vals[key] if !blacklist.include?(key.to_s)
    end

    cleansed_params
  end

  def self.build_object(admin_user_id, request_obj, params, blacklist_file, original_attrs, new_attrs)
    cleansed_params = self.cleanse(blacklist_file, params)
    changed_vals = self.get_changed_attributes(blacklist_file, original_attrs, new_attrs)

    {
      admin_user_id: admin_user_id,
      action: params[:action],
      data: {
        http_method: request_obj.method,
        params: cleansed_params,
        changes: changed_vals.present? ? changed_vals : nil
      },
      ip: request_obj.ip
    }
  end

  def self.get_changed_attributes(blacklist_file, original_attrs = {}, new_attrs = {})
    blacklist = self.get_blacklist(blacklist_file)
    changes = []

    original_attrs.keys.each do |key|
      if !blacklist.include?(key.to_s) && original_attrs[key] != new_attrs[key]
        changes.push({
          :"#{key.to_sym}" => {
            original_value: original_attrs[key],
            new_value: new_attrs[key]
          }
        })
      end
    end

    changes
  end

  def self.get_blacklist(blacklist_file)
    YAML.load_file("#{Rails.root.to_s}/config/blacklists/#{blacklist_file}").keys
  end
end