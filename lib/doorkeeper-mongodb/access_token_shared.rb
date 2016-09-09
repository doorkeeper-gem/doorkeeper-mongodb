module DoorkeeperMongodb
  module AccessTokenShared
    extend ActiveSupport::Concern

    module ClassMethods
      # https://github.com/doorkeeper-gem/doorkeeper/issues/862
      def last_authorized_token_for(application_id, resource_owner_id)
        send(order_method, created_at_desc)
          .where(application_id: application_id,
                 resource_owner_id: resource_owner_id,
                 revoked_at: nil).limit(1).first
      end

      def refresh_token_revoked_on_use?
        fields.collect { |field| field[0] }.include?('previous_refresh_token')
      end

      def created_at_desc
        [:created_at, :desc]
      end

      def order_method
        :order_by
      end

      private

      def delete_all_for(application_id, resource_owner)
        where(application_id: application_id,
              resource_owner_id: resource_owner.id).delete_all
      end
    end
  end
end
