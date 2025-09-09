import '../models/chat_response.dart';

class ChatBotService {
  static Map<String, ChatResponse> _getResponses(bool isArabic) {
    if (isArabic) {
      return _arabicResponses;
    } else {
      return _englishResponses;
    }
  }

  static final Map<String, ChatResponse> _arabicResponses = {
    // تحيات وترحيب
    'hello': ChatResponse(
      text:
          'مرحباً! أنا SkiBot، مساعدك الشخصي للتسوق الذكي. كيف يمكنني مساعدتك اليوم؟',
      suggestions: [
        ChatSuggestion(id: '1', text: 'كيف أبحث عن منتج؟', icon: '🔍'),
        ChatSuggestion(id: '2', text: 'مشاكل في التطبيق', icon: '⚠️'),
        ChatSuggestion(id: '3', text: 'حسابي', icon: '👤'),
        ChatSuggestion(id: '4', text: 'عروض اليوم', icon: '🎯'),
      ],
    ),
    'صباح الخير': ChatResponse(
      text:
          'صباح النور! 🌅 أتمنى لك يوماً مشرقاً مليئاً بالتسوق الممتع. كيف يمكنني مساعدتك اليوم؟',
      suggestions: [
        ChatSuggestion(id: '1', text: 'عروض الصباح', icon: '🌅'),
        ChatSuggestion(id: '2', text: 'منتجات طازجة', icon: '🥬'),
        ChatSuggestion(id: '3', text: 'قائمة التسوق', icon: '📝'),
      ],
    ),
    'مساء الخير': ChatResponse(
      text:
          'مساء النور! 🌙 أتمنى لك مساءً هادئاً. هل تريد التسوق لوجبة العشاء؟',
      suggestions: [
        ChatSuggestion(id: '1', text: 'مكونات العشاء', icon: '🍽️'),
        ChatSuggestion(id: '2', text: 'عروض المساء', icon: '🌙'),
        ChatSuggestion(id: '3', text: 'منتجات ساخنة', icon: '🔥'),
      ],
    ),
    'كيف حالك': ChatResponse(
      text:
          'أنا بخير، شكراً لك! 😊 أنا هنا دائماً لمساعدتك في التسوق. كيف يمكنني أن أكون مفيداً لك اليوم؟',
    ),
    'أهلاً': ChatResponse(
      text:
          'أهلاً وسهلاً! 👋 مرحباً بك في عالم التسوق الذكي. أنا SkiBot وسأكون دليلك في رحلة التسوق!',
    ),
    'hi': ChatResponse(
      text: 'أهلاً وسهلاً! أنا هنا لمساعدتك في التسوق. ما الذي تريد معرفته؟',
      suggestions: [
        ChatSuggestion(id: '1', text: 'كيف أستخدم التطبيق؟', icon: '📱'),
        ChatSuggestion(id: '2', text: 'البحث عن منتجات', icon: '🛍️'),
      ],
    ),
    'مرحبا': ChatResponse(
      text: 'مرحباً بك! أنا SkiBot، مساعدك الذكي. كيف يمكنني مساعدتك؟',
      suggestions: [
        ChatSuggestion(id: '1', text: 'كيف أبحث عن منتج؟', icon: '🔍'),
        ChatSuggestion(id: '2', text: 'مشاكل في التطبيق', icon: '⚠️'),
      ],
    ),

    // البحث عن المنتجات
    'search': ChatResponse(
      text:
          'يمكنك البحث عن المنتجات بعدة طرق:\n\n🔍 البحث بالاسم: اكتب اسم المنتج في شريط البحث\n📷 البحث بالصورة: استخدم كاميرا التطبيق لمسح المنتج\n🏷️ البحث بالباركود: امسح الباركود للحصول على معلومات المنتج\n\nأي طريقة تفضل؟',
      quickReplies: [
        QuickReply(id: '1', text: 'البحث بالاسم', payload: 'search_by_name'),
        QuickReply(id: '2', text: 'البحث بالصورة', payload: 'search_by_image'),
        QuickReply(
          id: '3',
          text: 'البحث بالباركود',
          payload: 'search_by_barcode',
        ),
      ],
    ),
    'عروض': ChatResponse(
      text:
          '🎯 لدينا عروض رائعة اليوم!\n\n🔥 عروض ساخنة: خصومات تصل إلى 50%\n🛒 عروض السلة: اشترِ 2 واحصل على 1 مجاناً\n⏰ عروض محدودة: لفترة محدودة فقط\n💳 عروض الدفع: خصم إضافي عند الدفع\n\nأي نوع من العروض يهمك؟',
      suggestions: [
        ChatSuggestion(id: '1', text: 'عروض الطعام', icon: '🍎'),
        ChatSuggestion(id: '2', text: 'عروض المشروبات', icon: '🥤'),
        ChatSuggestion(id: '3', text: 'عروض الحلويات', icon: '🍰'),
        ChatSuggestion(id: '4', text: 'عروض الخضروات', icon: '🥬'),
      ],
    ),
    'عروض اليوم': ChatResponse(
      text:
          '🌟 عروض اليوم المميزة:\n\n🥬 الخضروات الطازجة: خصم 30%\n🍎 الفواكه الموسمية: خصم 25%\n🥛 منتجات الألبان: خصم 20%\n🍞 المخبوزات: خصم 15%\n\nهل تريد رؤية تفاصيل أي عرض؟',
    ),
    'منتجات طازجة': ChatResponse(
      text:
          '🥬 المنتجات الطازجة وصلت للتو!\n\n✅ خضروات عضوية: طازجة من المزرعة\n✅ فواكه موسمية: حلوة ولذيذة\n✅ أعشاب طازجة: للطبخ الصحي\n✅ سلطات جاهزة: مغسولة ومقطعة\n\nأي منتج تريد إضافته لسلة التسوق؟',
    ),
    'قائمة التسوق': ChatResponse(
      text:
          '📝 دعني أساعدك في تنظيم قائمة التسوق!\n\n🛒 أضف المنتجات: اكتب ما تحتاجه\n📋 تنظيم القائمة: حسب الفئات\n💰 حساب التكلفة: معرفة المبلغ الإجمالي\n⏰ تذكيرات: لا تنس أي منتج\n\nماذا تريد إضافة لقائمتك؟',
    ),
    'كيف أبحث عن منتج': ChatResponse(
      text:
          'البحث عن المنتجات سهل جداً! إليك الطرق المتاحة:\n\n1️⃣ البحث بالاسم: اكتب ما تبحث عنه في شريط البحث\n2️⃣ البحث بالصورة: اضغط على أيقونة الكاميرا ووجهها نحو المنتج\n3️⃣ البحث بالباركود: امسح الباركود الموجود على المنتج\n\nأي طريقة تريد تجربتها؟',
      suggestions: [
        ChatSuggestion(id: '1', text: 'جرب البحث بالصورة', icon: '📷'),
        ChatSuggestion(id: '2', text: 'البحث بالباركود', icon: '📊'),
      ],
    ),
    'بحث': ChatResponse(
      text:
          'ممتاز! للبحث عن منتج:\n\n📱 في الصفحة الرئيسية: استخدم شريط البحث في الأعلى\n🔍 البحث المتقدم: يمكنك تصفية النتائج حسب السعر والعلامة التجارية\n📷 البحث البصري: التقط صورة للمنتج للحصول على نتائج دقيقة\n\nهل تحتاج مساعدة في طريقة معينة؟',
    ),

    // مشاكل التطبيق
    'problem': ChatResponse(
      text:
          'أعتذر عن أي مشكلة تواجهها! يمكنني مساعدتك في:\n\n🔧 مشاكل تقنية: بطء التطبيق، تعليق، أخطاء\n📱 مشاكل في الواجهة: أزرار لا تعمل، صفحات لا تفتح\n🔍 مشاكل البحث: نتائج غير دقيقة، بحث لا يعمل\n💳 مشاكل الدفع: مشاكل في عملية الشراء\n\nأي مشكلة تواجهها تحديداً؟',
      quickReplies: [
        QuickReply(id: '1', text: 'التطبيق بطيء', payload: 'slow_app'),
        QuickReply(id: '2', text: 'البحث لا يعمل', payload: 'search_issue'),
        QuickReply(id: '3', text: 'مشكلة في الدفع', payload: 'payment_issue'),
        QuickReply(id: '4', text: 'أزرار لا تعمل', payload: 'button_issue'),
      ],
    ),
    'مشاكل في التطبيق': ChatResponse(
      text:
          'لا تقلق! سأساعدك في حل المشكلة. أخبرني:\n\n❓ ما هي المشكلة بالضبط؟\n📱 متى تحدث؟\n🔄 هل جربت إعادة تشغيل التطبيق؟\n\nيمكنك أيضاً:\n• إعادة تشغيل التطبيق\n• التأكد من اتصال الإنترنت\n• تحديث التطبيق\n\nما هي المشكلة التي تواجهها؟',
    ),
    'مشكلة': ChatResponse(
      text:
          'أنا هنا لمساعدتك! أخبرني بالتفصيل عن المشكلة التي تواجهها وسأحاول حلها معك.',
    ),

    // الحساب
    'account': ChatResponse(
      text:
          'يمكنني مساعدتك في إدارة حسابك:\n\n👤 معلومات الحساب: عرض وتعديل البيانات الشخصية\n🔐 كلمة المرور: تغيير كلمة المرور\n📧 البريد الإلكتروني: تحديث البريد الإلكتروني\n📱 رقم الهاتف: تغيير رقم الهاتف\n🛒 طلباتي: عرض تاريخ الطلبات\n\nأي شيء تريد تعديله في حسابك؟',
      quickReplies: [
        QuickReply(id: '1', text: 'تعديل البيانات', payload: 'edit_profile'),
        QuickReply(
          id: '2',
          text: 'تغيير كلمة المرور',
          payload: 'change_password',
        ),
        QuickReply(id: '3', text: 'عرض الطلبات', payload: 'view_orders'),
      ],
    ),
    'حسابي': ChatResponse(
      text:
          'إدارة حسابك سهلة! يمكنك:\n\n✏️ تعديل معلوماتك الشخصية\n🔒 تغيير كلمة المرور\n📋 عرض طلباتك السابقة\n⚙️ تعديل إعدادات التطبيق\n\nأي شيء تريد فعله في حسابك؟',
    ),

    // الدفع والطلبات
    'payment': ChatResponse(
      text:
          'يمكنني مساعدتك في الدفع والطلبات:\n\n💳 طرق الدفع: بطاقة ائتمان، PayPal، دفع عند الاستلام\n🛒 إتمام الطلب: خطوات عملية الشراء\n📦 تتبع الطلب: معرفة حالة طلبك\n💰 الفاتورة: عرض تفاصيل الفاتورة\n\nأي مساعدة تحتاجها في الدفع؟',
    ),
    'طلب': ChatResponse(
      text:
          'ممتاز! لإنشاء طلب جديد:\n\n1️⃣ اختر المنتجات من نتائج البحث\n2️⃣ اضف للسلة المنتجات المطلوبة\n3️⃣ اذهب للسلة واختار الكمية\n4️⃣ اتبع خطوات الدفع لإتمام الطلب\n\nهل تحتاج مساعدة في أي خطوة؟',
    ),
    'توصيل': ChatResponse(
      text:
          '🚚 خدمة التوصيل متاحة 24/7!\n\n⚡ توصيل سريع: خلال 30 دقيقة\n🏠 توصيل مجاني: للطلبات فوق 50 ريال\n📱 تتبع مباشر: شاهد موقع التوصيل\n🕐 مواعيد مرنة: اختر الوقت المناسب\n\nأين تريد التوصيل؟',
      suggestions: [
        ChatSuggestion(id: '1', text: 'توصيل فوري', icon: '⚡'),
        ChatSuggestion(id: '2', text: 'توصيل مجاني', icon: '🆓'),
        ChatSuggestion(id: '3', text: 'تتبع الطلب', icon: '📍'),
      ],
    ),
    'سلة التسوق': ChatResponse(
      text:
          '🛒 سلة التسوق الخاصة بك:\n\n📋 عرض المنتجات: جميع المنتجات المختارة\n💰 حساب المجموع: السعر الإجمالي\n➕ تعديل الكمية: زيادة أو تقليل\n🗑️ حذف منتج: إزالة من السلة\n\nهل تريد إضافة المزيد أم المتابعة للدفع؟',
    ),
    'حالة الطلب': ChatResponse(
      text:
          '📦 تتبع طلبك:\n\n✅ تم الطلب: تم استلام طلبك\n👨‍🍳 قيد التحضير: يتم تجهيز طلبك\n🚚 في الطريق: الطلب في طريقه إليك\n🏠 تم التسليم: وصل طلبك بنجاح\n\nهل تريد معرفة تفاصيل أكثر؟',
    ),
    'إلغاء طلب': ChatResponse(
      text:
          '❌ يمكنك إلغاء الطلب في الحالات التالية:\n\n⏰ قبل التحضير: خلال 5 دقائق من الطلب\n🔄 استرداد فوري: عودة المبلغ خلال 24 ساعة\n📞 اتصل بنا: للاستفسارات العاجلة\n\nهل تريد المتابعة مع إلغاء الطلب؟',
    ),

    // المساعدة العامة
    'help': ChatResponse(
      text:
          'أنا هنا لمساعدتك! يمكنني مساعدتك في:\n\n🔍 البحث عن المنتجات\n🛒 عملية الشراء\n👤 إدارة الحساب\n🔧 حل المشاكل التقنية\n📱 استخدام التطبيق\n\nما الذي تريد معرفته؟',
      suggestions: [
        ChatSuggestion(id: '1', text: 'كيف أستخدم التطبيق؟', icon: '📱'),
        ChatSuggestion(id: '2', text: 'البحث عن منتجات', icon: '🔍'),
        ChatSuggestion(id: '3', text: 'مشاكل تقنية', icon: '🔧'),
      ],
    ),
    'مساعدة': ChatResponse(
      text:
          'بالطبع! أنا هنا لمساعدتك. يمكنني الإجابة على أسئلتك حول:\n\n• كيفية استخدام التطبيق\n• البحث عن المنتجات\n• إدارة حسابك\n• حل المشاكل التقنية\n• عملية الشراء\n\nما الذي تريد معرفته؟',
    ),

    // ردود عامة
    'thanks': ChatResponse(
      text:
          'العفو! أنا سعيد لأنني استطعت مساعدتك. هل هناك أي شيء آخر تريد معرفته؟',
    ),
    'شكرا': ChatResponse(
      text:
          'لا شكر على واجب! أنا هنا دائماً لمساعدتك. هل تحتاج مساعدة في شيء آخر؟',
    ),
    'ممتاز': ChatResponse(
      text:
          '🎉 رائع! أنا سعيد لأنك راضي عن المساعدة. هل تريد معرفة المزيد عن التطبيق؟',
    ),
    'رائع': ChatResponse(
      text: '😊 شكراً لك! أنا متحمس لمساعدتك أكثر. ماذا تريد أن نستكشف معاً؟',
    ),
    'مشكور': ChatResponse(
      text: '🤗 العفو! أنا هنا دائماً لخدمتك. هل تريد تجربة ميزة جديدة؟',
    ),
    'goodbye': ChatResponse(
      text:
          'وداعاً! أتمنى لك تجربة تسوق ممتعة. لا تتردد في العودة إذا احتجت أي مساعدة! 👋',
    ),
    'وداع': ChatResponse(
      text:
          'إلى اللقاء! أتمنى أن تكون تجربتك مع التطبيق ممتعة. أنا هنا دائماً لمساعدتك! 👋',
    ),
    'باي': ChatResponse(
      text: '👋 وداعاً! أتمنى لك يوماً رائعاً مليئاً بالتسوق الممتع!',
    ),
    'مع السلامة': ChatResponse(
      text: '👋 مع السلامة! أتمنى لك رحلة تسوق سعيدة ومفيدة!',
    ),
    // ردود تفاعلية إضافية
    'ماذا تفعل': ChatResponse(
      text:
          '🤖 أنا SkiBot، مساعدك الذكي! أستطيع:\n\n🔍 مساعدتك في البحث عن المنتجات\n🛒 إرشادك في عملية الشراء\n📱 حل مشاكل التطبيق\n💡 تقديم نصائح للتسوق الذكي\n\nماذا تريد أن نفعل معاً؟',
    ),
    'من أنت': ChatResponse(
      text:
          '👋 أنا SkiBot!\n\n🤖 مساعدك الذكي للتسوق\n💡 خبير في المنتجات والعروض\n🛒 دليلك الشخصي في عالم التسوق\n😊 صديقك المخلص في رحلة التسوق\n\nسعيد بلقائك! كيف يمكنني مساعدتك؟',
    ),
    'نصيحة': ChatResponse(
      text:
          '💡 إليك بعض النصائح الذكية:\n\n🛒 قارن الأسعار قبل الشراء\n📱 استخدم العروض المتاحة\n⏰ تسوق في الأوقات المناسبة للعروض\n📋 جهز قائمة قبل التسوق\n💰 راقب ميزانيتك دائماً\n\nهل تريد نصائح أكثر؟',
    ),
    'معلومات': ChatResponse(
      text:
          'ℹ️ معلومات مفيدة عن التطبيق:\n\n🕐 متاح 24/7 للخدمة\n🚚 توصيل سريع خلال 30 دقيقة\n💳 دفع آمن ومضمون\n🔄 استرداد سهل للطلبات\n📱 واجهة سهلة وبسيطة\n\nأي معلومة تريد معرفتها أكثر؟',
    ),
  };

  static final Map<String, ChatResponse> _englishResponses = {
    // Greetings
    'hello': ChatResponse(
      text:
          'Hello! I\'m SkiBot, your personal shopping assistant. How can I help you today?',
      suggestions: [
        ChatSuggestion(
          id: '1',
          text: 'How to search for products?',
          icon: '🔍',
        ),
        ChatSuggestion(id: '2', text: 'App issues', icon: '⚠️'),
        ChatSuggestion(id: '3', text: 'My account', icon: '👤'),
      ],
    ),
    'hi': ChatResponse(
      text:
          'Hi there! I\'m here to help you with shopping. What would you like to know?',
      suggestions: [
        ChatSuggestion(id: '1', text: 'How to use the app?', icon: '📱'),
        ChatSuggestion(id: '2', text: 'Search for products', icon: '🛍️'),
      ],
    ),

    // Product search
    'search': ChatResponse(
      text:
          'You can search for products in several ways:\n\n🔍 Search by name: Type the product name in the search bar\n📷 Search by image: Use the app camera to scan the product\n🏷️ Search by barcode: Scan the barcode to get product information\n\nWhich method do you prefer?',
      quickReplies: [
        QuickReply(id: '1', text: 'Search by name', payload: 'search_by_name'),
        QuickReply(
          id: '2',
          text: 'Search by image',
          payload: 'search_by_image',
        ),
        QuickReply(
          id: '3',
          text: 'Search by barcode',
          payload: 'search_by_barcode',
        ),
      ],
    ),
    'how to search for products': ChatResponse(
      text:
          'Searching for products is very easy! Here are the available methods:\n\n1️⃣ Search by name: Type what you\'re looking for in the search bar\n2️⃣ Search by image: Tap the camera icon and point it at the product\n3️⃣ Search by barcode: Scan the barcode on the product\n\nWhich method would you like to try?',
      suggestions: [
        ChatSuggestion(id: '1', text: 'Try image search', icon: '📷'),
        ChatSuggestion(id: '2', text: 'Search by barcode', icon: '📊'),
      ],
    ),
    'today\'s offers': ChatResponse(
      text:
          '🌟 Today\'s special offers:\n\n🥬 Fresh vegetables: 30% off\n🍎 Seasonal fruits: 25% off\n🥛 Dairy products: 20% off\n🍞 Bakery items: 15% off\n\nWould you like to see details of any offer?',
    ),
    'fresh products': ChatResponse(
      text:
          '🥬 Fresh products just arrived!\n\n✅ Organic vegetables: Fresh from the farm\n✅ Seasonal fruits: Sweet and delicious\n✅ Fresh herbs: For healthy cooking\n✅ Ready salads: Washed and cut\n\nWhich product would you like to add to your cart?',
    ),
    'delivery': ChatResponse(
      text:
          '🚚 Delivery service available 24/7!\n\n⚡ Fast delivery: Within 30 minutes\n🏠 Free delivery: For orders over 50 dollars\n📱 Live tracking: See delivery location\n🕐 Flexible times: Choose convenient time\n\nWhere would you like delivery?',
      suggestions: [
        ChatSuggestion(id: '1', text: 'Instant delivery', icon: '⚡'),
        ChatSuggestion(id: '2', text: 'Free delivery', icon: '🆓'),
        ChatSuggestion(id: '3', text: 'Track order', icon: '📍'),
      ],
    ),
    'my account': ChatResponse(
      text:
          'Managing your account is easy! You can:\n\n✏️ Edit your personal information\n🔒 Change your password\n📋 View your order history\n⚙️ Modify app settings\n\nWhat would you like to do with your account?',
    ),
    'general help': ChatResponse(
      text:
          'Of course! I\'m here to help. I can answer your questions about:\n\n• How to use the app\n• Product search\n• Account management\n• Technical problem solving\n• Shopping process\n\nWhat would you like to know?',
    ),

    // App issues
    'problem': ChatResponse(
      text:
          'Sorry for any issues you\'re experiencing! I can help you with:\n\n🔧 Technical issues: Slow app, freezing, errors\n📱 Interface issues: Buttons not working, pages not opening\n🔍 Search issues: Inaccurate results, search not working\n💳 Payment issues: Problems with checkout process\n\nWhat specific issue are you facing?',
      quickReplies: [
        QuickReply(id: '1', text: 'App is slow', payload: 'slow_app'),
        QuickReply(
          id: '2',
          text: 'Search not working',
          payload: 'search_issue',
        ),
        QuickReply(id: '3', text: 'Payment problem', payload: 'payment_issue'),
        QuickReply(
          id: '4',
          text: 'Buttons not working',
          payload: 'button_issue',
        ),
      ],
    ),
    'app issues': ChatResponse(
      text:
          'Don\'t worry! I\'ll help you solve the problem. Tell me:\n\n❓ What exactly is the problem?\n📱 When does it happen?\n🔄 Have you tried restarting the app?\n\nYou can also:\n• Restart the app\n• Check your internet connection\n• Update the app\n\nWhat problem are you experiencing?',
    ),
    'how to use the app': ChatResponse(
      text:
          '📱 Using the app is simple! Here\'s how:\n\n1️⃣ Browse products: Scroll through categories\n2️⃣ Search items: Use the search bar or camera\n3️⃣ Add to cart: Tap the + button\n4️⃣ Checkout: Review and pay\n5️⃣ Track order: Monitor delivery status\n\nWhich step would you like help with?',
      suggestions: [
        ChatSuggestion(id: '1', text: 'Browse products', icon: '🛍️'),
        ChatSuggestion(id: '2', text: 'Search items', icon: '🔍'),
        ChatSuggestion(id: '3', text: 'Add to cart', icon: '🛒'),
      ],
    ),
    'search for products': ChatResponse(
      text:
          '🔍 Product search made easy!\n\n📝 Text search: Type product name\n📷 Image search: Take a photo\n📊 Barcode scan: Scan product code\n🏷️ Category browse: Browse by type\n\nWhich search method interests you?',
    ),
    'technical issues': ChatResponse(
      text:
          '🔧 Let\'s fix those technical issues!\n\n🐌 Slow performance: Clear cache, restart app\n❌ App crashes: Update to latest version\n🔌 Connection problems: Check WiFi/data\n📱 Login issues: Reset password\n\nWhat specific technical problem are you facing?',
    ),

    // Account
    'account': ChatResponse(
      text:
          'I can help you manage your account:\n\n👤 Account info: View and edit personal data\n🔐 Password: Change your password\n📧 Email: Update your email\n📱 Phone: Change your phone number\n🛒 My orders: View order history\n\nWhat would you like to modify in your account?',
      quickReplies: [
        QuickReply(id: '1', text: 'Edit profile', payload: 'edit_profile'),
        QuickReply(
          id: '2',
          text: 'Change password',
          payload: 'change_password',
        ),
        QuickReply(id: '3', text: 'View orders', payload: 'view_orders'),
      ],
    ),

    // Payment and orders
    'payment': ChatResponse(
      text:
          'I can help you with payments and orders:\n\n💳 Payment methods: Credit card, PayPal, cash on delivery\n🛒 Complete order: Checkout process steps\n📦 Track order: Know your order status\n💰 Invoice: View invoice details\n\nWhat help do you need with payments?',
    ),
    'order': ChatResponse(
      text:
          'Great! To create a new order:\n\n1️⃣ Choose products from search results\n2️⃣ Add to cart the products you want\n3️⃣ Go to cart and select quantities\n4️⃣ Follow payment steps to complete the order\n\nDo you need help with any step?',
    ),

    // General help
    'help': ChatResponse(
      text:
          'I\'m here to help! I can assist you with:\n\n🔍 Product search\n🛒 Shopping process\n👤 Account management\n🔧 Technical problem solving\n📱 App usage\n\nWhat would you like to know?',
      suggestions: [
        ChatSuggestion(id: '1', text: 'How to use the app?', icon: '📱'),
        ChatSuggestion(id: '2', text: 'Search for products', icon: '🔍'),
        ChatSuggestion(id: '3', text: 'Technical issues', icon: '🔧'),
      ],
    ),

    // General responses
    'thanks': ChatResponse(
      text:
          'You\'re welcome! I\'m glad I could help you. Is there anything else you\'d like to know?',
    ),
    'excellent': ChatResponse(
      text:
          '🎉 Awesome! I\'m glad you\'re satisfied with the help. Would you like to know more about the app?',
    ),
    'great': ChatResponse(
      text:
          '😊 Thank you! I\'m excited to help you more. What would you like to explore together?',
    ),
    'goodbye': ChatResponse(
      text:
          'Goodbye! I hope you have a great shopping experience. Don\'t hesitate to come back if you need any help! 👋',
    ),
    'bye': ChatResponse(
      text: '👋 Bye! Have a wonderful day full of great shopping!',
    ),
    'what can you do': ChatResponse(
      text:
          '🤖 I\'m SkiBot, your smart assistant! I can:\n\n🔍 Help you search for products\n🛒 Guide you through the shopping process\n📱 Solve app issues\n💡 Provide smart shopping tips\n\nWhat would you like to do together?',
    ),
    'who are you': ChatResponse(
      text:
          '👋 I\'m SkiBot!\n\n🤖 Your smart shopping assistant\n💡 Expert in products and offers\n🛒 Your personal guide in the shopping world\n😊 Your loyal friend in your shopping journey\n\nNice to meet you! How can I help you?',
    ),
    'tips': ChatResponse(
      text:
          '💡 Here are some smart tips:\n\n🛒 Compare prices before buying\n📱 Use available offers\n⏰ Shop at the right times for deals\n📋 Prepare a list before shopping\n💰 Monitor your budget always\n\nWould you like more tips?',
    ),
    'info': ChatResponse(
      text:
          'ℹ️ Useful app information:\n\n🕐 Available 24/7 for service\n🚚 Fast delivery within 30 minutes\n💳 Secure payment guaranteed\n🔄 Easy refunds for orders\n📱 Simple interface and easy to use\n\nWhat information would you like to know more about?',
    ),
  };

  static ChatResponse getResponse(String message, {bool isArabic = true}) {
    String lowerMessage = message.toLowerCase().trim();
    final responses = _getResponses(isArabic);

    // البحث عن تطابق دقيق أولاً
    if (responses.containsKey(lowerMessage)) {
      return responses[lowerMessage]!;
    }

    // البحث عن كلمات مفتاحية
    for (String key in responses.keys) {
      if (lowerMessage.contains(key)) {
        return responses[key]!;
      }
    }

    if (isArabic) {
      // البحث في الكلمات العربية
      if (lowerMessage.contains('بحث') || lowerMessage.contains('منتج')) {
        return responses['search']!;
      }
      if (lowerMessage.contains('مشكلة') || lowerMessage.contains('خطأ')) {
        return responses['problem']!;
      }
      if (lowerMessage.contains('حساب') || lowerMessage.contains('بروفايل')) {
        return responses['account']!;
      }
      if (lowerMessage.contains('دفع') || lowerMessage.contains('طلب')) {
        return responses['payment']!;
      }
      if (lowerMessage.contains('مساعدة') || lowerMessage.contains('ساعد')) {
        return responses['help']!;
      }

      // رد افتراضي عربي
      return ChatResponse(
        text:
            'أعتذر، لم أفهم سؤالك. يمكنني مساعدتك في:\n\n🔍 البحث عن المنتجات\n🛒 عملية الشراء\n👤 إدارة الحساب\n🔧 حل المشاكل\n\nجرب سؤالاً مختلفاً أو اختر من الاقتراحات أدناه.',
        suggestions: [
          ChatSuggestion(id: '1', text: 'كيف أبحث عن منتج؟', icon: '🔍'),
          ChatSuggestion(id: '2', text: 'مشاكل في التطبيق', icon: '⚠️'),
          ChatSuggestion(id: '3', text: 'مساعدة عامة', icon: '❓'),
        ],
      );
    } else {
      // البحث في الكلمات الإنجليزية
      if (lowerMessage.contains('search') || lowerMessage.contains('product')) {
        return responses['search']!;
      }
      if (lowerMessage.contains('problem') ||
          lowerMessage.contains('issue') ||
          lowerMessage.contains('error')) {
        return responses['problem']!;
      }
      if (lowerMessage.contains('account') ||
          lowerMessage.contains('profile')) {
        return responses['account']!;
      }
      if (lowerMessage.contains('payment') || lowerMessage.contains('order')) {
        return responses['payment']!;
      }
      if (lowerMessage.contains('help') || lowerMessage.contains('assist')) {
        return responses['help']!;
      }

      // رد افتراضي إنجليزي
      return ChatResponse(
        text:
            'Sorry, I didn\'t understand your question. I can help you with:\n\n🔍 Product search\n🛒 Shopping process\n👤 Account management\n🔧 Problem solving\n\nTry a different question or choose from the suggestions below.',
        suggestions: [
          ChatSuggestion(
            id: '1',
            text: 'How to search for products?',
            icon: '🔍',
          ),
          ChatSuggestion(id: '2', text: 'App issues', icon: '⚠️'),
          ChatSuggestion(id: '3', text: 'General help', icon: '❓'),
        ],
      );
    }
  }

  static List<ChatSuggestion> getWelcomeSuggestions({bool isArabic = true}) {
    if (isArabic) {
      return [
        ChatSuggestion(id: '1', text: 'عروض اليوم', icon: '🎯'),
        ChatSuggestion(id: '2', text: 'كيف أبحث عن منتج؟', icon: '🔍'),
        ChatSuggestion(id: '3', text: 'منتجات طازجة', icon: '🥬'),
        ChatSuggestion(id: '4', text: 'توصيل', icon: '🚚'),
        ChatSuggestion(id: '5', text: 'حسابي', icon: '👤'),
        ChatSuggestion(id: '6', text: 'مساعدة عامة', icon: '❓'),
      ];
    } else {
      return [
        ChatSuggestion(id: '1', text: 'Today\'s offers', icon: '🎯'),
        ChatSuggestion(
          id: '2',
          text: 'How to search for products?',
          icon: '🔍',
        ),
        ChatSuggestion(id: '3', text: 'Fresh products', icon: '🥬'),
        ChatSuggestion(id: '4', text: 'Delivery', icon: '🚚'),
        ChatSuggestion(id: '5', text: 'My account', icon: '👤'),
        ChatSuggestion(id: '6', text: 'General help', icon: '❓'),
      ];
    }
  }
}
