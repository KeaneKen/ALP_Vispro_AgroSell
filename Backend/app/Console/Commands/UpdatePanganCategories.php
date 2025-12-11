<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Pangan;

class UpdatePanganCategories extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'pangan:update-categories';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Update pangan categories based on product names';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $this->info('Updating pangan categories...');
        
        $pangans = Pangan::all();
        $updated = 0;
        
        foreach ($pangans as $pangan) {
            $category = $this->detectCategory($pangan->Nama_Pangan);
            $pangan->category = $category;
            $pangan->save();
            $updated++;
            
            $this->line("Updated {$pangan->Nama_Pangan} -> {$category}");
        }
        
        $this->info("Successfully updated {$updated} products!");
        
        return 0;
    }
    
    private function detectCategory($namaPangan) {
        $name = strtolower($namaPangan);
        
        if (str_contains($name, 'padi') || str_contains($name, 'beras') || str_contains($name, 'gabah')) {
            return 'Padi';
        } elseif (str_contains($name, 'jagung') || str_contains($name, 'corn')) {
            return 'Jagung';
        } elseif (str_contains($name, 'cabai') || str_contains($name, 'cabe') || str_contains($name, 'chili')) {
            return 'Cabai';
        }
        
        return 'Lainnya';
    }
}

