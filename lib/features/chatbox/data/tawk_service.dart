// Service để quản lý Tawk.to integration
class TawkService {
  // Property ID từ Tawk.to dashboard
  static const String propertyId = '68839ac1db7610192eeaae69';

  // Widget ID (nếu có nhiều widgets)
  static const String widgetId = '1j111914a';

  // Javascript API key
  static const String apiKey = '90478d3c52663c0b305aac56b10018e026efb77f';

  // Tạo HTML content cho WebView
  static String getTawkHTML() {
    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <title>Chat Support</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        html, body {
            width: 100%;
            height: 100%;
            overflow: hidden;
            font-family: Arial, sans-serif;
            background-color: #ffffff;
        }
        
        body {
            position: relative;
        }
        
        .loading-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #FF6B35 0%, #F7931E 100%);
            z-index: 9999;
            transition: opacity 0.5s ease;
        }
        
        .loading-container.hidden {
            opacity: 0;
            pointer-events: none;
        }
        
        .loading-text {
            color: white;
            font-size: 18px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: 500;
        }
        
        .loading-spinner {
            border: 4px solid rgba(255,255,255,0.3);
            border-radius: 50%;
            border-top: 4px solid white;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        /* Tawk.to widget container */
        #tawk-container {
            width: 100%;
            height: 100%;
            opacity: 0;
            transition: opacity 0.5s ease;
        }
        
        #tawk-container.loaded {
            opacity: 1;
        }
        
        /* Hide Tawk.to default positioning */
        .tawk-widget {
            position: fixed !important;
            bottom: 0 !important;
            right: 0 !important;
            width: 100% !important;
            height: 100% !important;
            border: none !important;
            border-radius: 0 !important;
            box-shadow: none !important;
            z-index: 1000;
        }
    </style>
</head>
<body>
    <!-- Loading Screen -->
    <div class="loading-container" id="loading-container">
        <div class="loading-text">Đang kết nối hỗ trợ...</div>
        <div class="loading-spinner"></div>
    </div>
    
    <!-- Tawk.to Container -->
    <div id="tawk-container"></div>

    <!--Start of Tawk.to Script-->
    <script type="text/javascript">
        // Initialize Tawk_API before loading script
        var Tawk_API = Tawk_API || {};
        var Tawk_LoadStart = new Date();
        
        // Set visitor info before loading
        Tawk_API.visitor = {
            name: 'Flutter User',
            email: 'user@fastfood.app'
        };
        
        // Callback khi Tawk.to load xong
        Tawk_API.onLoad = function(){
            console.log('✅ Tawk.to loaded successfully');
            
            // Delay để đảm bảo widget được render
            setTimeout(function() {
                // Ẩn loading screen
                const loadingContainer = document.getElementById('loading-container');
                if (loadingContainer) {
                    loadingContainer.classList.add('hidden');
                }
                
                // Hiển thị chat container
                const tawkContainer = document.getElementById('tawk-container');
                if (tawkContainer) {
                    tawkContainer.classList.add('loaded');
                }
                
                // Tự động maximize chat widget
                try {
                    if (typeof Tawk_API.maximize === 'function') {
                        Tawk_API.maximize();
                    }
                } catch (e) {
                    console.log('Note: Could not auto-maximize chat');
                }
                
            }, 1000); // Wait 1 second for widget to fully load
        };
        
        // Callback khi widget sẵn sàng
        Tawk_API.onStatusChange = function(status){
            console.log('🔄 Tawk.to status changed:', status);
            if (status === 'online' || status === 'away') {
                // Widget is ready, hide loading if not already hidden
                setTimeout(function() {
                    const loadingContainer = document.getElementById('loading-container');
                    if (loadingContainer && !loadingContainer.classList.contains('hidden')) {
                        loadingContainer.classList.add('hidden');
                    }
                }, 500);
            }
        };
        
        // Callback khi chat bắt đầu
        Tawk_API.onChatStarted = function(){
            console.log('💬 Chat started');
        };
        
        // Callback khi nhận tin nhắn
        Tawk_API.onChatMessageVisitor = function(message){
            console.log('👤 Visitor message:', message);
        };
        
        // Callback khi agent trả lời
        Tawk_API.onChatMessageAgent = function(message){
            console.log('🎧 Agent message:', message);
        };
        
        // Callback khi offline
        Tawk_API.onOfflineSubmit = function(data){
            console.log('📧 Offline message submitted:', data);
        };
        
        // Load Tawk.to script
        (function(){
            var s1 = document.createElement("script");
            var s0 = document.getElementsByTagName("script")[0];
            s1.async = true;
            s1.src = 'https://embed.tawk.to/$propertyId/$widgetId';
            s1.charset = 'UTF-8';
            s1.setAttribute('crossorigin','*');
            
            // Add error handling for script loading
            s1.onerror = function() {
                console.error('❌ Failed to load Tawk.to script');
                // Hide loading and show error state
                const loadingContainer = document.getElementById('loading-container');
                if (loadingContainer) {
                    loadingContainer.innerHTML = '<div style="color: white; text-align: center;"><div style="font-size: 18px; margin-bottom: 10px;">Không thể kết nối</div><div style="font-size: 14px;">Vui lòng thử lại sau</div></div>';
                }
            };
            
            s0.parentNode.insertBefore(s1, s0);
        })();
        
        // Fallback: Hide loading after 10 seconds regardless
        setTimeout(function() {
            const loadingContainer = document.getElementById('loading-container');
            if (loadingContainer && !loadingContainer.classList.contains('hidden')) {
                console.log('⏰ Fallback: Hiding loading screen after timeout');
                loadingContainer.classList.add('hidden');
                
                const tawkContainer = document.getElementById('tawk-container');
                if (tawkContainer) {
                    tawkContainer.classList.add('loaded');
                }
            }
        }, 10000);
        
    </script>
    <!--End of Tawk.to Script-->
</body>
</html>
    ''';
  }

  // Tạo user info để gửi cho Tawk.to
  static Map<String, dynamic> getUserInfo() {
    return {
      'name': 'Flutter User',
      'email': 'user@fastfood.app',
      'hash': '', // Secure hash nếu cần
    };
  }

  // Set user attributes (simplified)
  static String setUserAttributes() {
    return '''
      // Wait for Tawk_API to be available
      if (typeof Tawk_API !== 'undefined' && Tawk_API.setAttributes) {
        try {
          Tawk_API.setAttributes({
            'name': 'Flutter User',
            'email': 'user@fastfood.app',
            'platform': 'Flutter Mobile App'
          });
          console.log('✅ User attributes set successfully');
        } catch (e) {
          console.log('⚠️ Could not set user attributes:', e);
        }
      } else {
        console.log('⚠️ Tawk_API.setAttributes not available yet');
      }
    ''';
  }
}
