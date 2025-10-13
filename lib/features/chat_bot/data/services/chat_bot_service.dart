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

    // أسئلة جديدة - التسوق والمنتجات
    'كيف أضيف منتج للسلة': ChatResponse(
      text:
          '🛒 إضافة المنتجات للسلة سهلة جداً!\n\n1️⃣ ابحث عن المنتج الذي تريده\n2️⃣ اضغط على زر "+" الأزرق\n3️⃣ سيظهر إشعار أخضر يؤكد الإضافة\n4️⃣ يمكنك الضغط على "عرض السلة" من الإشعار\n\nهل تريد معرفة كيفية تعديل الكميات؟',
      suggestions: [
        ChatSuggestion(id: '1', text: 'كيف أعدل الكمية؟', icon: '🔢'),
        ChatSuggestion(id: '2', text: 'كيف أحذف منتج؟', icon: '🗑️'),
        ChatSuggestion(id: '3', text: 'كيف أتم الطلب؟', icon: '✅'),
      ],
    ),
    'كيف أعدل الكمية': ChatResponse(
      text:
          '🔢 لتعديل كمية المنتج:\n\n1️⃣ اذهب إلى سلة التسوق\n2️⃣ ستجد أزرار + و - بجانب كل منتج\n3️⃣ اضغط + لزيادة الكمية\n4️⃣ اضغط - لتقليل الكمية\n5️⃣ السعر الإجمالي سيتحدث تلقائياً\n\nبسيطة جداً! 😊',
    ),
    'كيف أحذف منتج من السلة': ChatResponse(
      text:
          '🗑️ لحذف منتج من السلة:\n\n1️⃣ اذهب إلى سلة التسوق\n2️⃣ اسحب المنتج لليسار (swipe)\n3️⃣ أو اضغط على أيقونة سلة المهملات 🗑️\n4️⃣ المنتج سيحذف مباشرة\n\nيمكنك أيضاً تقليل الكمية إلى صفر!',
    ),
    'كيف أتم الطلب': ChatResponse(
      text:
          '✅ لإتمام الطلب:\n\n1️⃣ اذهب إلى سلة التسوق 🛒\n2️⃣ راجع المنتجات والكميات\n3️⃣ اضغط على "إتمام الطلب"\n4️⃣ أدخل بيانات الدفع\n5️⃣ اضغط "تأكيد الدفع"\n6️⃣ ستصلك الفاتورة مباشرة!\n\nهل تريد معرفة طرق الدفع المتاحة؟',
      suggestions: [
        ChatSuggestion(id: '1', text: 'طرق الدفع', icon: '💳'),
        ChatSuggestion(id: '2', text: 'كيف أتتبع طلبي؟', icon: '📦'),
      ],
    ),

    // أسئلة عن الماسح الضوئي
    'كيف أستخدم الماسح': ChatResponse(
      text:
          '📷 الماسح الضوئي ميزة رائعة!\n\n🔍 طريقتان للاستخدام:\n\n1️⃣ المسح التلقائي:\n   • اضغط على أيقونة الماسح 📱\n   • انتظر 5 ثواني\n   • سيظهر منتج عشوائي تلقائياً!\n\n2️⃣ مسح الباركود (على الجهاز الحقيقي):\n   • وجه الكاميرا نحو الباركود\n   • سيتعرف التطبيق على المنتج\n\nجرب الآن! 🎯',
      suggestions: [
        ChatSuggestion(id: '1', text: 'ما هو المسح العشوائي؟', icon: '🎲'),
        ChatSuggestion(id: '2', text: 'الماسح لا يعمل', icon: '⚠️'),
      ],
    ),
    'ما هو المسح العشوائي': ChatResponse(
      text:
          '🎲 المسح العشوائي ميزة ذكية!\n\n💡 الفكرة:\nبما أن الماسح لا يعمل على المحاكي، أضفنا ميزة "المسح العشوائي" التي تعرض منتجات عشوائية من قاعدة البيانات كل 5 ثواني!\n\n✨ الفوائد:\n• اكتشف منتجات جديدة\n• تجربة ممتعة\n• يعمل بدون جهاز حقيقي\n\nجربها الآن من أيقونة الماسح! 📱',
    ),
    'الماسح لا يعمل': ChatResponse(
      text:
          '⚠️ مشكلة في الماسح؟\n\n🔍 التشخيص:\n\n1️⃣ على المحاكي:\n   • الماسح الحقيقي لا يعمل على المحاكي\n   • استخدم ميزة "المسح العشوائي" بدلاً منه\n\n2️⃣ على الجهاز الحقيقي:\n   • تأكد من إذن الكاميرا\n   • تأكد من الإضاءة الجيدة\n   • نظف عدسة الكاميرا\n\n3️⃣ إذا استمرت المشكلة:\n   • أعد تشغيل التطبيق\n   • تحقق من تحديثات التطبيق\n\nهل تحتاج مساعدة أخرى؟',
    ),

    // أسئلة عن الحساب والأمان
    'كيف أغير كلمة السر': ChatResponse(
      text:
          '🔐 لتغيير كلمة السر:\n\n1️⃣ اذهب إلى "حسابي" 👤\n2️⃣ اضغط على "تغيير كلمة السر"\n3️⃣ أدخل كلمة السر الحالية\n4️⃣ أدخل كلمة السر الجديدة\n5️⃣ أكد كلمة السر الجديدة\n6️⃣ اضغط "حفظ"\n\n⚠️ تأكد من:\n• 8 أحرف على الأقل\n• تحتوي على أرقام وحروف\n• لا تشاركها مع أحد!',
      suggestions: [
        ChatSuggestion(id: '1', text: 'نسيت كلمة السر', icon: '🔑'),
        ChatSuggestion(id: '2', text: 'كيف أحمي حسابي؟', icon: '🛡️'),
      ],
    ),
    'نسيت كلمة السر': ChatResponse(
      text:
          '🔑 لا تقلق! يمكنك استعادتها:\n\n1️⃣ في صفحة تسجيل الدخول\n2️⃣ اضغط "نسيت كلمة السر؟"\n3️⃣ أدخل بريدك الإلكتروني\n4️⃣ سيصلك رمز التحقق\n5️⃣ أدخل الرمز\n6️⃣ أنشئ كلمة سر جديدة\n\n📧 تأكد من التحقق من صندوق البريد الوارد والرسائل غير المرغوب فيها!',
    ),
    'كيف أحمي حسابي': ChatResponse(
      text:
          '🛡️ نصائح لحماية حسابك:\n\n1️⃣ استخدم كلمة سر قوية\n   • 8 أحرف على الأقل\n   • أحرف وأرقام ورموز\n\n2️⃣ لا تشارك كلمة السر\n   • مع أي شخص كان!\n\n3️⃣ غير كلمة السر دورياً\n   • كل 3-6 أشهر\n\n4️⃣ تحقق من نشاط الحساب\n   • راجع طلباتك بانتظام\n\n5️⃣ سجل الخروج بعد الاستخدام\n   • خاصة على الأجهزة المشتركة\n\nأمانك مهم لنا! 🔒',
    ),

    // أسئلة عن العروض والخصومات
    'كيف أحصل على خصم': ChatResponse(
      text:
          '💰 طرق الحصول على خصومات:\n\n1️⃣ عروض اليوم 🎯\n   • تحقق من الصفحة الرئيسية يومياً\n   • خصومات تصل إلى 50%!\n\n2️⃣ كوبونات الخصم 🎟️\n   • ابحث عن كوبونات في التطبيق\n   • أدخل الكود عند الدفع\n\n3️⃣ عروض الباقات 📦\n   • اشترِ أكثر واحصل على خصم أكبر\n\n4️⃣ برنامج الولاء ⭐\n   • اجمع نقاط مع كل عملية شراء\n\nتابع العروض باستمرار! 🔔',
      suggestions: [
        ChatSuggestion(id: '1', text: 'عروض اليوم', icon: '🎯'),
        ChatSuggestion(id: '2', text: 'كيف أستخدم كوبون؟', icon: '🎟️'),
      ],
    ),
    'كيف أستخدم كوبون خصم': ChatResponse(
      text:
          '🎟️ لاستخدام كوبون الخصم:\n\n1️⃣ أضف المنتجات للسلة\n2️⃣ اذهب إلى صفحة الدفع\n3️⃣ ابحث عن حقل "كوبون الخصم"\n4️⃣ أدخل رمز الكوبون\n5️⃣ اضغط "تطبيق"\n6️⃣ سيتم خصم المبلغ تلقائياً!\n\n⚠️ ملاحظات:\n• كل كوبون له شروط خاصة\n• بعض الكوبونات لها تاريخ انتهاء\n• لا يمكن استخدام أكثر من كوبون واحد\n\nوفر الآن! 💵',
    ),

    // أسئلة عن اللغة والإعدادات
    'كيف أغير اللغة': ChatResponse(
      text:
          '🌍 لتغيير لغة التطبيق:\n\n1️⃣ اذهب إلى القائمة الجانبية ☰\n2️⃣ اضغط على "الإعدادات" ⚙️\n3️⃣ اختر "اللغة" 🌐\n4️⃣ اختر بين:\n   • العربية 🇸🇦\n   • English 🇬🇧\n5️⃣ التطبيق سيتحدث باللغة الجديدة فوراً!\n\nأنا أتكلم اللغتين! 😊',
    ),
    'كيف أتواصل مع الدعم': ChatResponse(
      text:
          '📞 طرق التواصل مع الدعم:\n\n1️⃣ الشات المباشر 💬\n   • أنا هنا لمساعدتك!\n   • متاح 24/7\n\n2️⃣ البريد الإلكتروني 📧\n   • support@skipline.com\n   • رد خلال 24 ساعة\n\n3️⃣ الهاتف 📱\n   • 920000000\n   • من السبت إلى الخميس\n   • 9 صباحاً - 5 مساءً\n\n4️⃣ وسائل التواصل 📱\n   • Twitter: @SkipLine\n   • Instagram: @SkipLine\n\nنحن هنا لخدمتك! 🤝',
      suggestions: [
        ChatSuggestion(id: '1', text: 'أريد تقديم شكوى', icon: '📝'),
        ChatSuggestion(id: '2', text: 'أريد تقديم اقتراح', icon: '💡'),
      ],
    ),
    'أريد تقديم شكوى': ChatResponse(
      text:
          '📝 نأسف لأي إزعاج!\n\nلتقديم شكوى:\n\n1️⃣ اذهب إلى "حسابي"\n2️⃣ اختر "المساعدة والدعم"\n3️⃣ اضغط "تقديم شكوى"\n4️⃣ اكتب تفاصيل المشكلة\n5️⃣ أرفق صور إن أمكن\n6️⃣ اضغط "إرسال"\n\n⏰ سنرد عليك خلال 24 ساعة\n\nرضاك يهمنا! 🙏',
    ),
    'أريد تقديم اقتراح': ChatResponse(
      text:
          '💡 نحن نحب الاقتراحات!\n\nلتقديم اقتراح:\n\n1️⃣ اذهب إلى "حسابي"\n2️⃣ اختر "المساعدة والدعم"\n3️⃣ اضغط "تقديم اقتراح"\n4️⃣ اكتب اقتراحك بالتفصيل\n5️⃣ اضغط "إرسال"\n\n🌟 أفضل الاقتراحات:\n• سيتم تطبيقها\n• صاحبها سيحصل على مكافأة!\n\nشاركنا أفكارك! 🚀',
    ),

    // أسئلة عن المشاكل الشائعة
    'التطبيق يتوقف': ChatResponse(
      text:
          '⚠️ التطبيق يتوقف؟ جرب هذه الحلول:\n\n1️⃣ أعد تشغيل التطبيق\n   • أغلقه تماماً وافتحه مرة أخرى\n\n2️⃣ امسح الذاكرة المؤقتة\n   • إعدادات الجهاز > التطبيقات > Skip Line\n   • امسح البيانات المؤقتة\n\n3️⃣ تحديث التطبيق\n   • تحقق من وجود تحديثات\n\n4️⃣ أعد تشغيل الجهاز\n   • أحياناً هذا يحل المشكلة!\n\n5️⃣ أعد تثبيت التطبيق\n   • احذفه وثبته من جديد\n\nإذا استمرت المشكلة، تواصل معنا! 📞',
    ),
    'الصور لا تظهر': ChatResponse(
      text:
          '🖼️ الصور لا تظهر؟\n\n🔍 الحلول:\n\n1️⃣ تحقق من الإنترنت\n   • الصور تحتاج اتصال جيد\n\n2️⃣ انتظر قليلاً\n   • الصور تحمل تدريجياً\n   • قد تأخذ بضع ثوان\n\n3️⃣ امسح الذاكرة المؤقتة\n   • إعدادات > التطبيقات > Skip Line\n\n4️⃣ تحقق من مساحة التخزين\n   • تأكد من وجود مساحة كافية\n\n5️⃣ أعد تشغيل التطبيق\n\nالصور ستظهر قريباً! 📸',
    ),
    'لا أستطيع تسجيل الدخول': ChatResponse(
      text:
          '🔐 مشكلة في تسجيل الدخول؟\n\n✅ تحقق من:\n\n1️⃣ البريد الإلكتروني\n   • هل كتبته بشكل صحيح؟\n   • لا توجد مسافات زائدة؟\n\n2️⃣ كلمة السر\n   • هل هي صحيحة؟\n   • تحقق من Caps Lock\n\n3️⃣ الحساب مفعّل؟\n   • تحقق من بريدك الإلكتروني\n   • ابحث عن رسالة التفعيل\n\n4️⃣ نسيت كلمة السر؟\n   • اضغط "نسيت كلمة السر"\n\n5️⃣ حساب جديد؟\n   • اضغط "إنشاء حساب جديد"\n\nهل تحتاج مساعدة أكثر؟ 🤝',
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

    // New questions - Shopping and Cart
    'how to add to cart': ChatResponse(
      text:
          '🛒 Adding products to cart is very easy!\n\n1️⃣ Search for the product you want\n2️⃣ Tap the blue "+" button\n3️⃣ A green notification will confirm the addition\n4️⃣ You can tap "View Cart" from the notification\n\nWould you like to know how to edit quantities?',
      suggestions: [
        ChatSuggestion(id: '1', text: 'How to edit quantity', icon: '🔢'),
        ChatSuggestion(id: '2', text: 'How to delete item', icon: '🗑️'),
        ChatSuggestion(id: '3', text: 'How to complete order', icon: '✅'),
      ],
    ),
    'how to edit quantity': ChatResponse(
      text:
          '🔢 To edit product quantity:\n\n1️⃣ Go to shopping cart\n2️⃣ You\'ll find + and - buttons next to each product\n3️⃣ Press + to increase quantity\n4️⃣ Press - to decrease quantity\n5️⃣ Total price will update automatically\n\nVery simple! 😊',
    ),
    'how to delete item': ChatResponse(
      text:
          '🗑️ To delete item from cart:\n\n1️⃣ Go to shopping cart\n2️⃣ Swipe the product to the left\n3️⃣ Or tap the trash icon 🗑️\n4️⃣ Product will be deleted immediately\n\nYou can also decrease quantity to zero!',
    ),
    'how to complete order': ChatResponse(
      text:
          '✅ To complete your order:\n\n1️⃣ Go to shopping cart 🛒\n2️⃣ Review products and quantities\n3️⃣ Tap "Complete Order"\n4️⃣ Enter payment details\n5️⃣ Tap "Confirm Payment"\n6️⃣ You\'ll receive the invoice immediately!\n\nWould you like to know available payment methods?',
      suggestions: [
        ChatSuggestion(id: '1', text: 'Payment methods', icon: '💳'),
        ChatSuggestion(id: '2', text: 'Track my order', icon: '📦'),
      ],
    ),

    // Scanner questions
    'how to use scanner': ChatResponse(
      text:
          '📷 The scanner is an amazing feature!\n\n🔍 Two ways to use:\n\n1️⃣ Auto Scan:\n   • Tap the scanner icon 📱\n   • Wait 5 seconds\n   • A random product will appear automatically!\n\n2️⃣ Barcode Scan (on real device):\n   • Point camera at barcode\n   • App will recognize the product\n\nTry it now! 🎯',
      suggestions: [
        ChatSuggestion(id: '1', text: 'What is random scan?', icon: '🎲'),
        ChatSuggestion(id: '2', text: 'Scanner not working', icon: '⚠️'),
      ],
    ),

    // Account and Security
    'change password': ChatResponse(
      text:
          '🔐 To change your password:\n\n1️⃣ Go to "My Account" 👤\n2️⃣ Tap "Change Password"\n3️⃣ Enter current password\n4️⃣ Enter new password\n5️⃣ Confirm new password\n6️⃣ Tap "Save"\n\n⚠️ Make sure:\n• At least 8 characters\n• Contains numbers and letters\n• Don\'t share it with anyone!',
      suggestions: [
        ChatSuggestion(id: '1', text: 'Forgot password', icon: '🔑'),
        ChatSuggestion(id: '2', text: 'Protect my account', icon: '🛡️'),
      ],
    ),
    'forgot password': ChatResponse(
      text:
          '🔑 Don\'t worry! You can recover it:\n\n1️⃣ On the login page\n2️⃣ Tap "Forgot Password?"\n3️⃣ Enter your email\n4️⃣ You\'ll receive a verification code\n5️⃣ Enter the code\n6️⃣ Create a new password\n\n📧 Check your inbox and spam folder!',
    ),

    // Offers and Discounts
    'how to get discount': ChatResponse(
      text:
          '💰 Ways to get discounts:\n\n1️⃣ Today\'s Offers 🎯\n   • Check homepage daily\n   • Discounts up to 50%!\n\n2️⃣ Discount Coupons 🎟️\n   • Look for coupons in the app\n   • Enter code at checkout\n\n3️⃣ Bundle Offers 📦\n   • Buy more, save more\n\n4️⃣ Loyalty Program ⭐\n   • Earn points with every purchase\n\nCheck offers regularly! 🔔',
      suggestions: [
        ChatSuggestion(id: '1', text: 'Today\'s offers', icon: '🎯'),
        ChatSuggestion(id: '2', text: 'Use coupon code', icon: '🎟️'),
      ],
    ),
    'use coupon code': ChatResponse(
      text:
          '🎟️ To use discount coupon:\n\n1️⃣ Add products to cart\n2️⃣ Go to payment page\n3️⃣ Find "Discount Coupon" field\n4️⃣ Enter coupon code\n5️⃣ Tap "Apply"\n6️⃣ Amount will be discounted automatically!\n\n⚠️ Notes:\n• Each coupon has specific conditions\n• Some coupons have expiry dates\n• Can\'t use more than one coupon\n\nSave now! 💵',
    ),

    // Settings
    'change language': ChatResponse(
      text:
          '🌍 To change app language:\n\n1️⃣ Go to side menu ☰\n2️⃣ Tap "Settings" ⚙️\n3️⃣ Select "Language" 🌐\n4️⃣ Choose between:\n   • العربية 🇸🇦\n   • English 🇬🇧\n5️⃣ App will switch to new language instantly!\n\nI speak both languages! 😊',
    ),
    'contact support': ChatResponse(
      text:
          '📞 Ways to contact support:\n\n1️⃣ Live Chat 💬\n   • I\'m here to help!\n   • Available 24/7\n\n2️⃣ Email 📧\n   • support@skipline.com\n   • Reply within 24 hours\n\n3️⃣ Phone 📱\n   • 920000000\n   • Saturday to Thursday\n   • 9 AM - 5 PM\n\n4️⃣ Social Media 📱\n   • Twitter: @SkipLine\n   • Instagram: @SkipLine\n\nWe\'re here to serve you! 🤝',
      suggestions: [
        ChatSuggestion(id: '1', text: 'Submit complaint', icon: '📝'),
        ChatSuggestion(id: '2', text: 'Submit suggestion', icon: '💡'),
      ],
    ),

    // Complaints and Suggestions
    'submit complaint': ChatResponse(
      text:
          '📝 Sorry for any inconvenience!\n\nTo submit a complaint:\n\n1️⃣ Go to "My Account"\n2️⃣ Select "Help & Support"\n3️⃣ Tap "Submit Complaint"\n4️⃣ Write problem details\n5️⃣ Attach photos if possible\n6️⃣ Tap "Send"\n\n⏰ We\'ll reply within 24 hours\n\nYour satisfaction matters! 🙏',
    ),
    'submit suggestion': ChatResponse(
      text:
          '💡 We love suggestions!\n\nTo submit a suggestion:\n\n1️⃣ Go to "My Account"\n2️⃣ Select "Help & Support"\n3️⃣ Tap "Submit Suggestion"\n4️⃣ Write your suggestion in detail\n5️⃣ Tap "Send"\n\n🌟 Best suggestions:\n• Will be implemented\n• Submitter gets a reward!\n\nShare your ideas! 🚀',
    ),

    // Common Problems
    'app crashes': ChatResponse(
      text:
          '⚠️ App crashing? Try these solutions:\n\n1️⃣ Restart the app\n   • Close completely and reopen\n\n2️⃣ Clear cache\n   • Device Settings > Apps > Skip Line\n   • Clear cache data\n\n3️⃣ Update the app\n   • Check for updates\n\n4️⃣ Restart device\n   • Sometimes this solves it!\n\n5️⃣ Reinstall the app\n   • Delete and install again\n\nIf problem persists, contact us! 📞',
    ),
  };

  static ChatResponse getResponse(String message, {bool isArabic = true}) {
    String lowerMessage = message.toLowerCase().trim();
    final responses = _getResponses(isArabic);

    print('🔍 ChatBotService - Searching for response');
    print('🔍 Original message: "$message"');
    print('🔍 Lower message: "$lowerMessage"');
    print('🔍 Language: ${isArabic ? "Arabic" : "English"}');

    // البحث عن تطابق دقيق أولاً
    if (responses.containsKey(lowerMessage)) {
      print('✅ Found exact match: "$lowerMessage"');
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
      // كلمات مفتاحية جديدة - التسوق والسلة
      if (lowerMessage.contains('أضيف') ||
          lowerMessage.contains('اضافة') ||
          lowerMessage.contains('إضافة')) {
        return responses['كيف أضيف منتج للسلة']!;
      }
      if (lowerMessage.contains('سلة') && !lowerMessage.contains('أضيف')) {
        return responses['سلة التسوق']!;
      }
      if (lowerMessage.contains('كمية') ||
          lowerMessage.contains('عدل') ||
          lowerMessage.contains('تعديل')) {
        return responses['كيف أعدل الكمية']!;
      }
      if (lowerMessage.contains('حذف') ||
          lowerMessage.contains('مسح') ||
          lowerMessage.contains('إزالة')) {
        return responses['كيف أحذف منتج من السلة']!;
      }
      if (lowerMessage.contains('قائمة') && lowerMessage.contains('تسوق')) {
        return responses['قائمة التسوق']!;
      }
      if (lowerMessage.contains('حالة') && lowerMessage.contains('طلب')) {
        return responses['حالة الطلب']!;
      }

      // كلمات مفتاحية - الماسح
      if (lowerMessage.contains('ماسح') ||
          lowerMessage.contains('سكانر') ||
          lowerMessage.contains('باركود')) {
        return responses['كيف أستخدم الماسح']!;
      }
      if (lowerMessage.contains('مسح عشوائي') ||
          lowerMessage.contains('عشوائي')) {
        return responses['ما هو المسح العشوائي']!;
      }

      // كلمات مفتاحية - الحساب والأمان
      if (lowerMessage.contains('كلمة السر') ||
          lowerMessage.contains('الباسورد') ||
          lowerMessage.contains('password')) {
        return responses['كيف أغير كلمة السر']!;
      }
      if (lowerMessage.contains('نسيت') &&
          (lowerMessage.contains('كلمة') || lowerMessage.contains('سر'))) {
        return responses['نسيت كلمة السر']!;
      }
      if (lowerMessage.contains('حمي') ||
          lowerMessage.contains('أمان') ||
          lowerMessage.contains('حماية')) {
        return responses['كيف أحمي حسابي']!;
      }

      // كلمات مفتاحية - العروض والخصومات
      if (lowerMessage.contains('خصم') || lowerMessage.contains('تخفيض')) {
        return responses['كيف أحصل على خصم']!;
      }
      if (lowerMessage.contains('كوبون') || lowerMessage.contains('كود')) {
        return responses['كيف أستخدم كوبون خصم']!;
      }

      // كلمات مفتاحية - الإعدادات
      if (lowerMessage.contains('لغة') ||
          lowerMessage.contains('عربي') ||
          lowerMessage.contains('انجليزي')) {
        return responses['كيف أغير اللغة']!;
      }
      if (lowerMessage.contains('دعم') ||
          lowerMessage.contains('تواصل') ||
          lowerMessage.contains('اتصال')) {
        return responses['كيف أتواصل مع الدعم']!;
      }

      // كلمات مفتاحية - الشكاوى والاقتراحات
      if (lowerMessage.contains('شكوى') || lowerMessage.contains('شكوا')) {
        return responses['أريد تقديم شكوى']!;
      }
      if (lowerMessage.contains('اقتراح') || lowerMessage.contains('فكرة')) {
        return responses['أريد تقديم اقتراح']!;
      }

      // كلمات مفتاحية - المشاكل الشائعة
      if (lowerMessage.contains('يتوقف') ||
          lowerMessage.contains('يقفل') ||
          lowerMessage.contains('crash')) {
        return responses['التطبيق يتوقف']!;
      }
      if (lowerMessage.contains('صور') ||
          lowerMessage.contains('صورة') ||
          lowerMessage.contains('image')) {
        return responses['الصور لا تظهر']!;
      }
      if (lowerMessage.contains('تسجيل دخول') ||
          lowerMessage.contains('دخول') ||
          lowerMessage.contains('login')) {
        return responses['لا أستطيع تسجيل الدخول']!;
      }

      // كلمات مفتاحية - إضافية
      if (lowerMessage.contains('نصيحة') || lowerMessage.contains('نصائح')) {
        return responses['نصيحة']!;
      }
      if (lowerMessage.contains('معلومات') || lowerMessage.contains('معلومة')) {
        return responses['معلومات']!;
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
      if (lowerMessage.contains('payment')) {
        return responses['payment']!;
      }
      if (lowerMessage.contains('help') || lowerMessage.contains('assist')) {
        return responses['help']!;
      }

      // كلمات مفتاحية جديدة - Shopping and Cart
      if (lowerMessage.contains('add') && lowerMessage.contains('cart')) {
        return responses['how to add to cart']!;
      }
      if (lowerMessage.contains('edit') && lowerMessage.contains('quantity')) {
        return responses['how to edit quantity']!;
      }
      if (lowerMessage.contains('delete') && lowerMessage.contains('item')) {
        return responses['how to delete item']!;
      }
      if (lowerMessage.contains('complete') && lowerMessage.contains('order')) {
        return responses['how to complete order']!;
      }

      // كلمات مفتاحية - Scanner
      if (lowerMessage.contains('scanner') ||
          lowerMessage.contains('scan') ||
          lowerMessage.contains('barcode')) {
        return responses['how to use scanner']!;
      }

      // كلمات مفتاحية - Account and Security
      if (lowerMessage.contains('change') &&
          lowerMessage.contains('password')) {
        return responses['change password']!;
      }
      if (lowerMessage.contains('forgot') &&
          lowerMessage.contains('password')) {
        return responses['forgot password']!;
      }

      // كلمات مفتاحية - Offers and Discounts
      if (lowerMessage.contains('discount') || lowerMessage.contains('offer')) {
        print('✅ Found keyword: discount/offer');
        return responses['how to get discount']!;
      }
      if (lowerMessage.contains('coupon') || lowerMessage.contains('code')) {
        print('✅ Found keyword: coupon/code');
        return responses['use coupon code']!;
      }

      // كلمات مفتاحية - Settings
      if (lowerMessage.contains('language') ||
          lowerMessage.contains('change language')) {
        return responses['change language']!;
      }
      if (lowerMessage.contains('support') ||
          lowerMessage.contains('contact')) {
        return responses['contact support']!;
      }

      // كلمات مفتاحية - Complaints and Suggestions
      if (lowerMessage.contains('submit complaint') ||
          lowerMessage.contains('complaint')) {
        return responses['submit complaint']!;
      }
      if (lowerMessage.contains('submit suggestion') ||
          lowerMessage.contains('suggestion')) {
        return responses['submit suggestion']!;
      }

      // كلمات مفتاحية - Common Problems
      if (lowerMessage.contains('crash') ||
          lowerMessage.contains('crashes') ||
          lowerMessage.contains('app crashes')) {
        return responses['app crashes']!;
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
      // قائمة كاملة بجميع الاقتراحات المتاحة
      final allSuggestions = [
        // اقتراحات عامة
        ChatSuggestion(id: '1', text: 'عروض اليوم', icon: '🎯'),
        ChatSuggestion(id: '2', text: 'كيف أبحث عن منتج؟', icon: '🔍'),
        ChatSuggestion(id: '3', text: 'منتجات طازجة', icon: '🥬'),
        ChatSuggestion(id: '4', text: 'توصيل', icon: '🚚'),
        ChatSuggestion(id: '5', text: 'حسابي', icon: '👤'),
        ChatSuggestion(id: '6', text: 'مساعدة عامة', icon: '❓'),

        // اقتراحات التسوق والسلة
        ChatSuggestion(id: '7', text: 'كيف أضيف منتج للسلة', icon: '🛒'),
        ChatSuggestion(id: '8', text: 'كيف أعدل الكمية', icon: '🔢'),
        ChatSuggestion(id: '9', text: 'كيف أحذف منتج من السلة', icon: '🗑️'),
        ChatSuggestion(id: '10', text: 'كيف أتم الطلب', icon: '✅'),

        // اقتراحات الماسح
        ChatSuggestion(id: '11', text: 'كيف أستخدم الماسح', icon: '📷'),
        ChatSuggestion(id: '12', text: 'ما هو المسح العشوائي', icon: '🎲'),
        ChatSuggestion(id: '13', text: 'الماسح لا يعمل', icon: '⚠️'),

        // اقتراحات الحساب والأمان
        ChatSuggestion(id: '14', text: 'كيف أغير كلمة السر', icon: '🔐'),
        ChatSuggestion(id: '15', text: 'نسيت كلمة السر', icon: '🔑'),
        ChatSuggestion(id: '16', text: 'كيف أحمي حسابي', icon: '🛡️'),

        // اقتراحات العروض والخصومات
        ChatSuggestion(id: '17', text: 'كيف أحصل على خصم', icon: '💰'),
        ChatSuggestion(id: '18', text: 'كيف أستخدم كوبون خصم', icon: '🎟️'),

        // اقتراحات الإعدادات
        ChatSuggestion(id: '19', text: 'كيف أغير اللغة', icon: '🌍'),
        ChatSuggestion(id: '20', text: 'كيف أتواصل مع الدعم', icon: '📞'),

        // اقتراحات الشكاوى والاقتراحات
        ChatSuggestion(id: '21', text: 'أريد تقديم شكوى', icon: '📝'),
        ChatSuggestion(id: '22', text: 'أريد تقديم اقتراح', icon: '💡'),

        // اقتراحات المشاكل الشائعة
        ChatSuggestion(id: '23', text: 'التطبيق يتوقف', icon: '⚠️'),
        ChatSuggestion(id: '24', text: 'الصور لا تظهر', icon: '🖼️'),
        ChatSuggestion(id: '25', text: 'لا أستطيع تسجيل الدخول', icon: '🔐'),

        // اقتراحات إضافية
        ChatSuggestion(id: '26', text: 'قائمة التسوق', icon: '📝'),
        ChatSuggestion(id: '27', text: 'سلة التسوق', icon: '🛒'),
        ChatSuggestion(id: '28', text: 'حالة الطلب', icon: '📦'),
        ChatSuggestion(id: '29', text: 'نصيحة', icon: '💡'),
        ChatSuggestion(id: '30', text: 'معلومات', icon: 'ℹ️'),
      ];

      // خلط القائمة وإرجاع 6 اقتراحات عشوائية
      allSuggestions.shuffle();
      return allSuggestions.take(6).toList();
    } else {
      // قائمة كاملة بجميع الاقتراحات الإنجليزية
      final allSuggestions = [
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
        ChatSuggestion(id: '7', text: 'How to add to cart', icon: '🛒'),
        ChatSuggestion(id: '8', text: 'How to edit quantity', icon: '🔢'),
        ChatSuggestion(id: '9', text: 'How to delete item', icon: '🗑️'),
        ChatSuggestion(id: '10', text: 'How to complete order', icon: '✅'),
        ChatSuggestion(id: '11', text: 'How to use scanner', icon: '📷'),
        ChatSuggestion(id: '12', text: 'Change password', icon: '🔐'),
        ChatSuggestion(id: '13', text: 'Forgot password', icon: '🔑'),
        ChatSuggestion(id: '14', text: 'How to get discount', icon: '💰'),
        ChatSuggestion(id: '15', text: 'Use coupon code', icon: '🎟️'),
        ChatSuggestion(id: '16', text: 'Change language', icon: '🌍'),
        ChatSuggestion(id: '17', text: 'Contact support', icon: '📞'),
        ChatSuggestion(id: '18', text: 'Submit complaint', icon: '📝'),
        ChatSuggestion(id: '19', text: 'Submit suggestion', icon: '💡'),
        ChatSuggestion(id: '20', text: 'App crashes', icon: '⚠️'),
      ];

      // خلط القائمة وإرجاع 6 اقتراحات عشوائية
      allSuggestions.shuffle();
      return allSuggestions.take(6).toList();
    }
  }
}
