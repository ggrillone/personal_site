class AuditLogDataStruct
  attr_accessor :audited_user_id, :save_to_model, :http_request_object,
    :http_request_params, :original_attributes_before_update,
    :new_attributes_after_update, :blacklist_file

  def initialize(args = {})
    begin
      set_required_attributes(args)
    rescue AuditLogException::MissingArguments => e
      raise AuditLogException::MissingArguments
      Rails.logger.info "[#{Time.now.utc}] AuditLogException::MissingArguments #{e}"
    end

    begin
      set_optional_attributes(args)
    rescue AuditLogException::FileNotFound => e
      raise AuditLogException::FileNotFound
      Rails.logger.info "[#{Time.now.utc}] AuditLogException::FileNotFound #{e}"
    end
  end

  private

    def set_required_attributes(args)
      exception_msg = ''

      if !args.has_key?(:audited_user_id)
        exception_msg += 'Missing key audited_user_id. '
      end

      if !args.has_key?(:http_request_object)
        exception_msg += 'Missing key http_request_object. '
      end
      
      if !args.has_key?(:http_request_params)
        exception_msg += 'Missing key http_request_params. '
      end

      if !args.has_key?(:save_to_model)
        exception_msg += 'Missing key save_to_model. '
      else
        check_if_model_exists(args[:save_to_model])
      end

      if exception_msg.empty?
        self.audited_user_id = args[:audited_user_id]
        self.http_request_params = args[:http_request_object]
        self.http_request_params = args[:http_request_params]
        self.save_to_model = args[:save_to_model]
      else
        raise AuditLogException::MissingArguments.new(exception_msg)
      end
    end

    def set_optional_attributes(args)
      if args.has_key?(:blacklist_file)
        check_if_blacklist_file_exists(args[:blacklist_file])
      end

      self.blacklist_file =
        args.has_key?(:blacklist_file) ?
          "#{Rails.root}/config/blacklists/#{args[:blacklist_file]}" :
            nil
      self.original_attributes_before_update =
        args.has_key?(:original_attributes_before_update) ?
          args[:original_attributes_before_update] :
            nil
      self.new_attributes_after_update =
        args.has_key?(:new_attributes_after_update) ?
          args[:new_attributes_after_update] :
            nil
    end

    def check_if_blacklist_file_exists(blacklist_file)
      if !File.exist?("#{Rails.root}/config/blacklists/#{blacklist_file}")
        raise AuditLogException::FileNotFound.new('File not found for argument key blacklist_file.')
      end
    end

    def check_if_model_exists(model_str)
      begin
        model_str.constantize
      rescue
        raise AuditLogException::ModelDoesNotExist
        Rails.logger.info "[#{Time.now.utc}] AuditLogException::ModelDoesNotExist for argument save_to_model: #{model_str}"
      end
    end
end






# ##
# # A generic module for creating log records
# # in the database

# module AuditLog
#   # @params resource The resource rails model to save the log to.
#   # @params admin_user_id The id of the current admin user performing the action.
#   # @params request_obj The entire request object sent from the controller.
#   # @params params The params passed into the request.
#   # @params blacklist_file The .yml file which contains
#   # list of attributes that should not be saved in the log.
#   # It is expected that all blacklist files are saved under
#   # the config/blacklists directory.
#   def self.create(resource_model, admin_user_id, request_obj, params, blacklist_file, original_attrs, new_attrs)
#     Rails.logger.info '--- REQUEST OBJECT ---'
#     Rails.logger.info request_obj.method
#     Rails.logger.info request_obj.ip
#     audit_log_data = self.build_object(admin_user_id, request_obj, params, blacklist_file, original_attrs, new_attrs)
#     resource_model.create(audit_log_data)
#   end

#   def self.cleanse(blacklist_file, vals)
#     blacklist = self.get_blacklist(blacklist_file)
#     cleansed_params = nil

#     if vals.is_a?(Array)
#       cleansed_params = []
#       vals.each do |val|
#         cleansed_params.push(self.cleanse_vals_from_hash(blacklist, val))
#       end
#     else
#       cleansed_params = self.cleanse_vals_from_hash(blacklist, vals)
#     end
    

#     cleansed_params
#   end

#   def self.cleanse_vals_from_hash(blacklist, vals = {})
#     cleansed_params = {}

#     vals.keys.each do |key|
#       if vals[key].is_a?(Hash)
#         cleansed_params[key] = {}

#         vals[key].keys.each do |sub_key|
#           cleansed_params[key][sub_key] = vals[key][sub_key] if !blacklist.include?(sub_key.to_s)
#         end
#       elsif vals[key].is_a?(Array)
#         cleansed_params[key] = []

#         vals[key].each do |obj|
#           if obj.is_a?(Hash)
#             obj.keys.each do |obj_key|
#               cleansed_params[key].push(obj[obj_key])
#             end
#           else
#             cleansed_params[key].push(obj)
#           end
#         end
#       else
#         cleansed_params[key] = vals[key] if !blacklist.include?(key.to_s)
#       end
#     end

#     cleansed_params
#   end

#   def self.build_object(admin_user_id, request_obj, params, blacklist_file, original_attrs, new_attrs)
#     cleansed_params = self.cleanse(blacklist_file, params)
#     changed_vals = (original_attrs.nil? && new_attrs.nil?) ? nil : self.get_changed_attributes(blacklist_file, original_attrs, new_attrs)
#     action = "#{params[:controller].classify.demodulize}##{params[:action]}"

#     {
#       admin_user_id: admin_user_id,
#       action: action,
#       data: {
#         raw_data: {
#           http_method: request_obj.method,
#           params: cleansed_params,
#           changes: changed_vals.present? ? changed_vals : nil
#         }.to_json
#       },
#       ip: request_obj.ip
#     }
#   end

#   def self.get_changed_attributes(blacklist_file, original_attrs = {}, new_attrs = {})
#     original_attrs_cleansed = self.cleanse(blacklist_file, original_attrs)
#     new_attrs_cleansed = self.cleanse(blacklist_file, new_attrs)
#     changes = nil    

#     # Covers batch actions
#     if original_attrs_cleansed.is_a?(Array)
#       original_attrs_cleansed.each_with_index do |original_attr, index|
#         self.compare_original_attrs_and_new_attrs(original_attr, new_attrs_cleansed[index])
#       end
#     else
#       changes = self.compare_original_attrs_and_new_attrs(original_attrs_cleansed, new_attrs_cleansed)
#     end
    
#   end

#   def self.compare_original_attrs_and_new_attrs(original_attrs, new_attrs)
#     changes = []

#     original_attrs.keys.each do |key|
#       if original_attrs[key].is_a?(Hash)
#         changes.push({ :"#{key.to_sym}" => {} })

#         original_attrs[key].keys.each do |sub_key|
#           if original_attrs[key][sub_key] != new_attrs[key][sub_key]
#             changes.last[key][sub_key] = {
#               :"#{sub_key.to_sym}" => {
#                 original_value: original_attrs[key][sub_key],
#                 new_value: new_attrs[key][sub_key]
#               }
#             }
#           end
#         end
#       elsif original_attrs[key].is_a?(Array)
#         changes.push({
#           :"#{key.to_sym}" => {
#             original_value: original_attrs[key],
#             new_value: new_attrs[key]
#           }
#         })
#       else
#         if original_attrs[key] != new_attrs[key]
#           changes.push({
#             :"#{key.to_sym}" => {
#               original_value: original_attrs[key],
#               new_value: new_attrs[key]
#             }
#           })
#         end
#       end
#     end

#     changes
#   end

#   def self.get_blacklist(blacklist_file)
#     YAML.load_file("#{Rails.root.to_s}/config/blacklists/#{blacklist_file}").keys
#   end
# end