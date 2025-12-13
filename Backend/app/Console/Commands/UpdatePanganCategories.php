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
        } elseif (str_contains($name, 'sayur') || str_contains($name, 'kangkung') || str_contains($name, 'bayam') || 
                 str_contains($name, 'sawi') || str_contains($name, 'wortel') || str_contains($name, 'tomat') ||
                 str_contains($name, 'terong') || str_contains($name, 'kubis') || str_contains($name, 'kol') ||
                 str_contains($name, 'brokoli') || str_contains($name, 'selada') || str_contains($name, 'timun') ||
                 str_contains($name, 'labu') || str_contains($name, 'buncis') || str_contains($name, 'kacang panjang')) {
            return 'Sayuran';
        } elseif (str_contains($name, 'buah') || str_contains($name, 'apel') || str_contains($name, 'jeruk') ||
                 str_contains($name, 'mangga') || str_contains($name, 'pisang') || str_contains($name, 'pepaya') ||
                 str_contains($name, 'semangka') || str_contains($name, 'melon') || str_contains($name, 'anggur') ||
                 str_contains($name, 'durian') || str_contains($name, 'rambutan') || str_contains($name, 'salak') ||
                 str_contains($name, 'manggis') || str_contains($name, 'nanas') || str_contains($name, 'alpukat')) {
            return 'Buah';
        }
        
        return 'Lainnya';
    }
}

