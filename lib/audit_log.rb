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
      if vals[key].is_a?(Hash)
        cleansed_params[key] = {}

        vals[key].keys.each do |sub_key|
          cleansed_params[key][sub_key] = vals[key][sub_key] if !blacklist.include?(sub_key.to_s)
        end
      elsif vals[key].is_a?(Array)
        cleansed_params[key] = []

        vals[key].each do |obj|
          if obj.is_a?(Hash)
            obj.keys.each do |obj_key|
              cleansed_params[key].push(obj[obj_key])
            end
          else
            cleansed_params[key].push(obj)
          end
        end
      else
        cleansed_params[key] = vals[key] if !blacklist.include?(key.to_s)
      end
    end

    cleansed_params
  end

  def self.build_object(admin_user_id, request_obj, params, blacklist_file, original_attrs, new_attrs)
    cleansed_params = self.cleanse(blacklist_file, params)
    changed_vals = (original_attrs.nil? && new_attrs.nil?) ? nil : self.get_changed_attributes(blacklist_file, original_attrs, new_attrs)
    action = "#{params[:controller].classify.demodulize}##{params[:action]}"

    {
      admin_user_id: admin_user_id,
      action: action,
      data: {
        raw_data: {
          http_method: request_obj.method,
          params: cleansed_params,
          changes: changed_vals.present? ? changed_vals : nil
        }.to_json
      },
      ip: request_obj.ip
    }
  end

  def self.get_changed_attributes(blacklist_file, original_attrs = {}, new_attrs = {})
    original_attrs_cleansed = self.cleanse(blacklist_file, original_attrs)
    new_attrs_cleansed = self.cleanse(blacklist_file, new_attrs)
    changes = []

    original_attrs_cleansed.keys.each do |key|
      if original_attrs_cleansed[key].is_a?(Hash)
        changes.push({ :"#{key.to_sym}" => {} })

        original_attrs_cleansed[key].keys.each do |sub_key|
          if original_attrs_cleansed[key][sub_key] != new_attrs_cleansed[key][sub_key]
            changes.last[key][sub_key] = {
              :"#{sub_key.to_sym}" => {
                original_value: original_attrs_cleansed[key][sub_key],
                new_value: new_attrs_cleansed[key][sub_key]
              }
            }
          end
        end
      elsif original_attrs_cleansed[key].is_a?(Array)
        changes.push({
          :"#{key.to_sym}" => {
            original_value: original_attrs_cleansed[key],
            new_value: new_attrs_cleansed[key]
          }
        })
      else
        if original_attrs_cleansed[key] != new_attrs_cleansed[key]
          changes.push({
            :"#{key.to_sym}" => {
              original_value: original_attrs_cleansed[key],
              new_value: new_attrs_cleansed[key]
            }
          })
        end
      end
    end

    changes
  end

  def self.get_blacklist(blacklist_file)
    YAML.load_file("#{Rails.root.to_s}/config/blacklists/#{blacklist_file}").keys
  end
end