class HTTP::Server::Context
  property current_user : User?
end

class Authenticate < Amber::Pipe::Base
  PUBLIC_PATHS = ["/", "/session/", "/signinup/", "/registration/"]

  def call(context)
    user_id = context.session["user_id"]?
    if user = User.find user_id
      context.current_user = user
      call_next(context)
    else
      return call_next(context) if public_path?(context.request.path)
      context.flash[:warning] = "Please Sign In"
      context.response.headers.add "Location", "/signinup/?next=#{context.request.path}"
      context.response.status_code = 302
    end
  end

  private def public_path?(path)
    # Remove everything after the query string first
    path = path.split("?")[0]
    PUBLIC_PATHS.includes?(path)

    # Different strategies can be used to determine if a path is public
    # Example, if /admin/* paths are the only private paths
    # return false if path.starts_with?("/admin")
    #
    # Example, if only a few private paths exist
    # return false if ["/secret", "/super/secret", "/private"].includes?(path)
  end
end
