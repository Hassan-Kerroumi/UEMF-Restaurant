import { useState } from 'react';
import { Search } from 'lucide-react';
import { useApp } from '../../contexts/AppContext';
import { products, categories } from '../../data/mockData';
import { OrderModal } from '../OrderModal';
import { Product } from '../../data/mockData';
import { CategoryScroll } from '../CategoryScroll';

export function UserHome() {
  const { t, language } = useApp();
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedProduct, setSelectedProduct] = useState<Product | null>(null);
  const [isModalOpen, setIsModalOpen] = useState(false);

  const creditBalance = 125.50;
  const studentName = 'Ahmed Ali';

  const filteredProducts = products.filter((product) => {
    const matchesCategory = !selectedCategory || product.category === selectedCategory;
    const matchesSearch = !searchQuery || 
      product.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      product.nameFr.toLowerCase().includes(searchQuery.toLowerCase()) ||
      product.nameAr.includes(searchQuery);
    return matchesCategory && matchesSearch;
  });

  const suggestions = products.slice(0, 5);

  const handleOrderClick = (product: Product) => {
    setSelectedProduct(product);
    setIsModalOpen(true);
  };

  return (
    <div className="pb-20 pt-16">
      {/* Header */}
      <div className="bg-gradient-to-r from-[#062c6b] to-[#0a4099] text-white p-6 rounded-b-3xl shadow-lg">
        <div className="flex justify-between items-center mb-2">
          <div>
            <p className="text-sm opacity-90">Welcome back,</p>
            <h2 className="text-xl">{studentName}</h2>
          </div>
          <div className="text-right">
            <p className="text-sm opacity-90">{t('creditBalance')}</p>
            <p className="text-xl">${creditBalance}</p>
          </div>
        </div>
      </div>

      <div className="px-4 pt-6 space-y-6">
        {/* Search */}
        <div className="relative">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground" size={20} />
          <input
            type="text"
            placeholder={t('search')}
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full pl-10 pr-4 py-3 rounded-xl bg-card border border-border focus:outline-none focus:ring-2 focus:ring-[#3cad2a]"
          />
        </div>

        {/* Categories */}
        <div>
          <h3 className="mb-3 px-4">{t('categories')}</h3>
          <CategoryScroll
            selectedCategory={selectedCategory}
            onCategorySelect={setSelectedCategory}
            categories={categories}
          />
        </div>

        {/* Products Grid */}
        <div className="grid grid-cols-2 gap-4">
          {filteredProducts.map((product) => {
            const productName = language === 'fr' ? product.nameFr : language === 'ar' ? product.nameAr : product.name;
            return (
              <div
                key={product.id}
                className="bg-card rounded-xl overflow-hidden shadow-md hover:shadow-lg transition-shadow"
              >
                <img
                  src={product.image}
                  alt={productName}
                  className="w-full h-32 object-cover"
                />
                <div className="p-3 space-y-2">
                  <h4 className="text-sm line-clamp-1">{productName}</h4>
                  <div className="flex items-center justify-between">
                    <span className="text-lg text-[#3cad2a]">${product.price}</span>
                    <button
                      onClick={() => handleOrderClick(product)}
                      className="px-3 py-1 bg-[#3cad2a] text-white text-sm rounded-lg hover:bg-[#3cad2a]/90 transition-colors"
                    >
                      {t('order')}
                    </button>
                  </div>
                </div>
              </div>
            );
          })}
        </div>

        {/* Suggestions */}
        <div>
          <h3 className="mb-3">{t('suggestions')}</h3>
          <div className="flex gap-4 overflow-x-auto pb-2 scrollbar-hide">
            {suggestions.map((product) => {
              const productName = language === 'fr' ? product.nameFr : language === 'ar' ? product.nameAr : product.name;
              return (
                <div
                  key={product.id}
                  className="bg-card rounded-xl overflow-hidden shadow-md min-w-[160px] cursor-pointer hover:shadow-lg transition-shadow"
                  onClick={() => handleOrderClick(product)}
                >
                  <img
                    src={product.image}
                    alt={productName}
                    className="w-full h-24 object-cover"
                  />
                  <div className="p-2">
                    <h4 className="text-sm line-clamp-1">{productName}</h4>
                    <p className="text-[#3cad2a]">${product.price}</p>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </div>

      <OrderModal
        product={selectedProduct}
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
      />

      <style>{`
        .scrollbar-hide::-webkit-scrollbar {
          display: none;
        }
        .scrollbar-hide {
          -ms-overflow-style: none;
          scrollbar-width: none;
        }
      `}</style>
    </div>
  );
}
