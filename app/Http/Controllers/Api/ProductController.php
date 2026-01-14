<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Product;
use App\Jobs\ProcessProduct;

class ProductController extends Controller
{
    /**
     * Create a new product and dispatch a queued job for processing.
     */
    public function store(Request $request)
    {
        $data = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'nullable|numeric|min:0',
        ]);

        $product = Product::create($data);

        // Dispatch a job to the 'products' queue (handled via RabbitMQ when configured)
        ProcessProduct::dispatch($product)->onQueue('products');

        return response()->json([
            'product' => $product,
            'queued' => true,
        ], 201);
    }
}
