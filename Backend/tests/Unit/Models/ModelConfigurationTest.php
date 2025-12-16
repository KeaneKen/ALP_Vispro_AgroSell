<?php

namespace Tests\Unit\Models;

use App\Models\Cart;
use App\Models\Pangan;
use App\Models\Payment;
// use App\Models\Perusahaan;
use App\Models\Riwayat;
use Illuminate\Container\Container;
use Illuminate\Database\Capsule\Manager as Capsule;
use Illuminate\Database\Eloquent\Model as EloquentModel;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Events\Dispatcher;
use PHPUnit\Framework\TestCase;

class ModelConfigurationTest extends TestCase
{
    private static bool $eloquentBootstrapped = false;

    protected function setUp(): void
    {
        parent::setUp();

        if (! self::$eloquentBootstrapped) {
            $this->bootstrapEloquent();
            self::$eloquentBootstrapped = true;
        }
    }

    private function bootstrapEloquent(): void
    {
        $capsule = new Capsule();

        $capsule->addConnection([
            'driver' => 'sqlite',
            'database' => ':memory:',
            'prefix' => '',
        ]);

        $capsule->setEventDispatcher(new Dispatcher(new Container()));
        $capsule->setAsGlobal();
        $capsule->bootEloquent();

        EloquentModel::setConnectionResolver($capsule->getDatabaseManager());
        EloquentModel::setEventDispatcher(new Dispatcher(new Container()));
    }

    // Commented out as Perusahaan model doesn't exist
    // public function test_perusahaan_configuration(): void
    // {
    //     $model = new Perusahaan();

    //     $this->assertSame('perusahaan', $model->getTable());
    //     $this->assertSame('idPerusahaan', $model->getKeyName());
    //     $this->assertFalse($model->getIncrementing());
    //     $this->assertSame('string', $model->getKeyType());
    //     $this->assertSame([
    //         'idPerusahaan',
    //         'Nama_Perusahaan',
    //         'Email_Perusahaan',
    //         'Password_Perusahaan',
    //         'Alamat_Perusahaan',
    //         'NoTelp_Perusahaan',
    //         'created_at',
    //         'updated_at',
    //     ], $model->getFillable());
    // }

    // public function test_perusahaan_has_many_mitra(): void
    // {
    //     $relation = (new Perusahaan())->mitra();

    //     $this->assertInstanceOf(HasMany::class, $relation);
    // }

    public function test_pangan_configuration(): void
    {
        $model = new Pangan();

        $this->assertSame('pangan', $model->getTable());
        $this->assertSame('idPangan', $model->getKeyName());
        $this->assertFalse($model->getIncrementing());
        $this->assertSame('string', $model->getKeyType());
        $this->assertSame([
            'idPangan',
            'Nama_Pangan',
            'Deskripsi_Pangan',
            'Harga_Pangan',
            'idFoto_Pangan',
            'category',
            'created_at',
            'updated_at',
        ], $model->getFillable());
        $this->assertSame('decimal:2', $model->getCasts()['Harga_Pangan'] ?? null);
    }

    public function test_pangan_relationships(): void
    {
        $model = new Pangan();

        // Only test carts relationship as mitra relationship has been removed
        $this->assertInstanceOf(HasMany::class, $model->carts());
    }

    public function test_cart_configuration(): void
    {
        $model = new Cart();

        $this->assertSame('cart', $model->getTable());
        $this->assertSame('idCart', $model->getKeyName());
        $this->assertFalse($model->getIncrementing());
        $this->assertSame('string', $model->getKeyType());
        $this->assertSame([
            'idCart',
            'idPangan',
            'Jumlah_Pembelian',
            'created_at',
            'updated_at',
        ], $model->getFillable());
        $this->assertSame('integer', $model->getCasts()['Jumlah_Pembelian'] ?? null);
    }

    public function test_cart_relationships(): void
    {
        $model = new Cart();

        $this->assertInstanceOf(BelongsTo::class, $model->pangan());
        $this->assertInstanceOf(HasOne::class, $model->payment());
    }

    public function test_payment_configuration(): void
    {
        $model = new Payment();

        $this->assertSame('payment', $model->getTable());
        $this->assertSame('idPayment', $model->getKeyName());
        $this->assertFalse($model->getIncrementing());
        $this->assertSame('string', $model->getKeyType());
        $this->assertSame([
            'idPayment',
            'idCart',
            'Total_Harga',
            'created_at',
            'updated_at',
        ], $model->getFillable());
        $this->assertSame('decimal:2', $model->getCasts()['Total_Harga'] ?? null);
    }

    public function test_payment_relationships(): void
    {
        $model = new Payment();

        $this->assertInstanceOf(BelongsTo::class, $model->cart());
        $this->assertInstanceOf(HasOne::class, $model->riwayat());
    }

    public function test_riwayat_configuration_and_relationship(): void
    {
        $model = new Riwayat();

        $this->assertSame('riwayat', $model->getTable());
        $this->assertSame('idHistory', $model->getKeyName());
        $this->assertFalse($model->getIncrementing());
        $this->assertSame('string', $model->getKeyType());
        $this->assertSame([
            'idHistory',
            'idPayment',
            'created_at',
            'updated_at',
        ], $model->getFillable());
        $this->assertInstanceOf(BelongsTo::class, $model->payment());
    }
}
