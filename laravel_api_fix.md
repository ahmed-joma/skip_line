# إصلاح Laravel API للمنتجات

## المشكلة
المسار `/api/v1/products` غير موجود في Laravel API

## الحل

### 1. إضافة المسار في `routes/api.php`
```php
<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductController;

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// إضافة مسار المنتجات
Route::get('/products', [ProductController::class, 'index']);
```

### 2. إنشاء ProductController
```bash
php artisan make:controller ProductController
```

### 3. إضافة الكود في `app/Http/Controllers/ProductController.php`
```php
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function index()
    {
        $products = [
            'status' => true,
            'code' => 200,
            'msg' => 'Return products successfully',
            'data' => [
                'best_sellers' => [
                    [
                        'id' => 22,
                        'image_url' => 'http://127.0.0.1:8000/storage/uploads/images/products/croissant.jpg',
                        'name_en' => 'Croissant',
                        'name_ar' => 'كرواسون',
                        'unit_en' => 'pcs',
                        'unit_ar' => 'قطعة',
                        'sale_price' => '1.00',
                        'is_favorite' => false
                    ],
                    [
                        'id' => 21,
                        'image_url' => 'http://127.0.0.1:8000/storage/uploads/images/products/bread.jpg',
                        'name_en' => 'Bread Loaf',
                        'name_ar' => 'رغيف خبز',
                        'unit_en' => 'pcs',
                        'unit_ar' => 'قطعة',
                        'sale_price' => '1.50',
                        'is_favorite' => false
                    ],
                    [
                        'id' => 23,
                        'image_url' => 'http://127.0.0.1:8000/storage/uploads/images/products/cookies.jpg',
                        'name_en' => 'Chocolate Chip Cookies',
                        'name_ar' => 'بسكويت برقائق الشوكولاتة',
                        'unit_en' => 'pack',
                        'unit_ar' => 'علبة',
                        'sale_price' => '2.50',
                        'is_favorite' => false
                    ]
                ],
                'exclusiveOffers' => [
                    [
                        'id' => 5,
                        'image_url' => 'http://127.0.0.1:8000/storage/uploads/images/products/watermelon.png',
                        'name_en' => 'Watermelon',
                        'name_ar' => 'بطيخ',
                        'unit_en' => 'pcs',
                        'unit_ar' => 'حبة',
                        'sale_price' => '6.00',
                        'is_favorite' => false
                    ],
                    [
                        'id' => 4,
                        'image_url' => 'http://127.0.0.1:8000/storage/uploads/images/products/grapes.png',
                        'name_en' => 'Grapes balck',
                        'name_ar' => 'عنب أسود',
                        'unit_en' => 'kg',
                        'unit_ar' => 'كجم',
                        'sale_price' => '5.00',
                        'is_favorite' => false
                    ],
                    [
                        'id' => 19,
                        'image_url' => 'http://127.0.0.1:8000/storage/uploads/images/products/coffee.jpg',
                        'name_en' => 'Coffee 200g',
                        'name_ar' => 'قهوة 200 جم',
                        'unit_en' => 'g',
                        'unit_ar' => 'جم',
                        'sale_price' => '5.00',
                        'is_favorite' => false
                    ]
                ]
            ]
        ];

        return response()->json($products);
    }
}
```

### 4. تشغيل الخادم
```bash
php artisan serve
```

## النتيجة المتوقعة
بعد إضافة هذا الكود، سيعمل التطبيق ويعرض المنتجات بشكل صحيح.

## ملاحظات
- تأكد من أن الخادم يعمل على `http://127.0.0.1:8000`
- تأكد من أن المسار `/api/v1/products` يعمل
- يمكنك إضافة المزيد من المنتجات حسب الحاجة
