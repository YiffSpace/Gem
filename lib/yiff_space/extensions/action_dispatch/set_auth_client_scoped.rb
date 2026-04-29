module YiffSpace
  module Extensions
    module ActionDispatch
      module SetAuthClientScoped
        def yiffspace_set_auth_client(name, &)
          constraints(Auth::SetClientName.new(name), &)
        end
      end
    end
  end
end
