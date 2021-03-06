module FacebookHelper
  def init_facebook_js_sdk_async
    %|
    <div id="fb-root"></div>
    <script type='text/javascript'>
      window.fbAsyncInit = function() {
        FB.init({appId: '#{Facebook::APP_ID}',
                 status: true,
                 cookie: true,
                 xfbml: true
        });

        window.setTimeout(function() {
          scrollTo(0,0); // prevent confusion when navigating from long page to short page by navigating to the top
          FB.Canvas.setAutoResize(); // auto resize iframe size to prevent scroll bars (must be enabled in the app's settings)
        }, 250);

        facebook_init_callback();

        FB.getLoginStatus(function(response) {
          if (response.session) {
            facebook_login_callback(response.session);
          } else {
            facebook_didnt_login_callback(response.session);
          }
        });
      };

      (function() {
        var e = document.createElement('script');
        e.type = 'text/javascript';
        e.src = document.location.protocol +
        '//connect.facebook.net/en_US/all.js';
        e.async = true;
        document.getElementById('fb-root').appendChild(e);
      }());
    </script>
    |
  end
end
