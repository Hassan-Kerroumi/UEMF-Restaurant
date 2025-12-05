import { useState } from 'react';
import { Search, Plus, Edit, Trash2, X, Upload } from 'lucide-react';
import { useApp } from '../../contexts/AppContext';
import { products, categories } from '../../data/mockData';
import { toast } from 'sonner@2.0.3';
import { CategoryScroll } from '../CategoryScroll';
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '../ui/dialog';

export function AdminProducts() {
  const { t, language } = useApp();
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);
  const [isAddDialogOpen, setIsAddDialogOpen] = useState(false);
  const [isEditDialogOpen, setIsEditDialogOpen] = useState(false);
  const [editingProduct, setEditingProduct] = useState<any>(null);
  
  // Form states
  const [formData, setFormData] = useState({
    nameEn: '',
    nameFr: '',
    nameAr: '',
    price: '',
    category: '',
    image: '',
  });

  const filteredProducts = products.filter((product) => {
    const matchesCategory = !selectedCategory || product.category === selectedCategory;
    const matchesSearch = !searchQuery || 
      product.name.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesCategory && matchesSearch;
  });

  const handleEdit = (product: any) => {
    setEditingProduct(product);
    setFormData({
      nameEn: product.name,
      nameFr: product.nameFr,
      nameAr: product.nameAr,
      price: product.price.toString(),
      category: product.category,
      image: product.image,
    });
    setIsEditDialogOpen(true);
  };

  const handleDelete = (productName: string) => {
    if (confirm(`Are you sure you want to delete ${productName}?`)) {
      toast.error(`Deleted ${productName}`);
    }
  };

  const handleAddNew = () => {
    setFormData({
      nameEn: '',
      nameFr: '',
      nameAr: '',
      price: '',
      category: categories[0]?.id || '',
      image: '',
    });
    setIsAddDialogOpen(true);
  };

  const handleSubmitAdd = () => {
    if (!formData.nameEn || !formData.price || !formData.category) {
      toast.error('Please fill in required fields');
      return;
    }
    toast.success(`Product "${formData.nameEn}" added successfully!`);
    setIsAddDialogOpen(false);
  };

  const handleSubmitEdit = () => {
    if (!formData.nameEn || !formData.price || !formData.category) {
      toast.error('Please fill in required fields');
      return;
    }
    toast.success(`Product "${formData.nameEn}" updated successfully!`);
    setIsEditDialogOpen(false);
  };

  return (
    <div className="pb-20 pt-16 px-4">
      <div className="flex items-center justify-between mb-4">
        <h2 className="text-[#c74242]">{t('products')}</h2>
        <button
          onClick={handleAddNew}
          className="flex items-center gap-2 px-4 py-2 bg-[#c74242] text-white rounded-lg hover:bg-[#c74242]/90 transition-colors"
        >
          <Plus size={18} />
          {t('addNew')}
        </button>
      </div>

      {/* Search */}
      <div className="relative mb-6">
        <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground" size={20} />
        <input
          type="text"
          placeholder={t('search')}
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="w-full pl-10 pr-4 py-3 rounded-xl bg-card border border-border focus:outline-none focus:ring-2 focus:ring-[#c74242]"
        />
      </div>

      {/* Categories */}
      <div className="mb-6">
        <h3 className="mb-3 px-4">{t('categories')}</h3>
        <CategoryScroll
          selectedCategory={selectedCategory}
          onCategorySelect={setSelectedCategory}
          categories={categories}
          mode="admin"
        />
      </div>

      {/* Products Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        {filteredProducts.map((product) => {
          const productName = language === 'fr' ? product.nameFr : language === 'ar' ? product.nameAr : product.name;
          return (
            <div
              key={product.id}
              className="bg-card rounded-xl overflow-hidden shadow-md border border-border hover:shadow-lg transition-shadow"
            >
              <div className="relative">
                <img
                  src={product.image}
                  alt={productName}
                  className="w-full h-40 object-cover"
                />
                <div className="absolute top-2 right-2 flex gap-2">
                  <button
                    onClick={() => handleEdit(product)}
                    className="p-2 bg-white/90 backdrop-blur-sm rounded-lg hover:bg-white transition-colors"
                  >
                    <Edit size={16} className="text-blue-500" />
                  </button>
                  <button
                    onClick={() => handleDelete(productName)}
                    className="p-2 bg-white/90 backdrop-blur-sm rounded-lg hover:bg-white transition-colors"
                  >
                    <Trash2 size={16} className="text-red-500" />
                  </button>
                </div>
              </div>
              <div className="p-4">
                <div className="flex items-start justify-between mb-2">
                  <div className="flex-1">
                    <h4 className="mb-1">{productName}</h4>
                    <p className="text-xs text-muted-foreground capitalize">
                      {product.category.replace('-', ' ')}
                    </p>
                  </div>
                  <span className="text-xl text-[#c74242]">${product.price}</span>
                </div>
              </div>
            </div>
          );
        })}
      </div>

      {/* Add Product Dialog */}
      <Dialog open={isAddDialogOpen} onOpenChange={setIsAddDialogOpen}>
        <DialogContent className="sm:max-w-md max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>Add New Product</DialogTitle>
          </DialogHeader>
          
          <div className="space-y-4">
            <div>
              <label className="block text-sm mb-2">Product Name (English) *</label>
              <input
                type="text"
                value={formData.nameEn}
                onChange={(e) => setFormData({ ...formData, nameEn: e.target.value })}
                className="w-full p-3 rounded-lg bg-card border border-border text-foreground focus:outline-none focus:ring-2 focus:ring-[#c74242]"
                placeholder="Espresso"
              />
            </div>

            <div>
              <label className="block text-sm mb-2">Product Name (French)</label>
              <input
                type="text"
                value={formData.nameFr}
                onChange={(e) => setFormData({ ...formData, nameFr: e.target.value })}
                className="w-full p-3 rounded-lg bg-card border border-border text-foreground focus:outline-none focus:ring-2 focus:ring-[#c74242]"
                placeholder="Espresso"
              />
            </div>

            <div>
              <label className="block text-sm mb-2">Product Name (Arabic)</label>
              <input
                type="text"
                value={formData.nameAr}
                onChange={(e) => setFormData({ ...formData, nameAr: e.target.value })}
                className="w-full p-3 rounded-lg bg-card border border-border text-foreground focus:outline-none focus:ring-2 focus:ring-[#c74242]"
                placeholder="إسبريسو"
              />
            </div>

            <div>
              <label className="block text-sm mb-2">Price *</label>
              <input
                type="number"
                step="0.01"
                value={formData.price}
                onChange={(e) => setFormData({ ...formData, price: e.target.value })}
                className="w-full p-3 rounded-lg bg-card border border-border text-foreground focus:outline-none focus:ring-2 focus:ring-[#c74242]"
                placeholder="5.00"
              />
            </div>

            <div>
              <label className="block text-sm mb-2">Category *</label>
              <select
                value={formData.category}
                onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                className="w-full p-3 rounded-lg bg-card border border-border text-foreground focus:outline-none focus:ring-2 focus:ring-[#c74242]"
              >
                {categories.map((cat) => (
                  <option key={cat.id} value={cat.id} className="bg-card text-foreground">
                    {cat.name}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="block text-sm mb-2">Image URL</label>
              <input
                type="text"
                value={formData.image}
                onChange={(e) => setFormData({ ...formData, image: e.target.value })}
                className="w-full p-3 rounded-lg bg-card border border-border text-foreground focus:outline-none focus:ring-2 focus:ring-[#c74242]"
                placeholder="https://..."
              />
            </div>

            <div className="flex gap-2 pt-4">
              <button
                onClick={() => setIsAddDialogOpen(false)}
                className="flex-1 py-3 border border-border rounded-lg hover:bg-muted transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={handleSubmitAdd}
                className="flex-1 py-3 bg-[#c74242] text-white rounded-lg hover:bg-[#c74242]/90 transition-colors"
              >
                Add Product
              </button>
            </div>
          </div>
        </DialogContent>
      </Dialog>

      {/* Edit Product Dialog */}
      <Dialog open={isEditDialogOpen} onOpenChange={setIsEditDialogOpen}>
        <DialogContent className="sm:max-w-md max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>Edit Product</DialogTitle>
          </DialogHeader>
          
          <div className="space-y-4">
            <div>
              <label className="block text-sm mb-2">Product Name (English) *</label>
              <input
                type="text"
                value={formData.nameEn}
                onChange={(e) => setFormData({ ...formData, nameEn: e.target.value })}
                className="w-full p-3 rounded-lg bg-card border border-border text-foreground focus:outline-none focus:ring-2 focus:ring-[#c74242]"
              />
            </div>

            <div>
              <label className="block text-sm mb-2">Product Name (French)</label>
              <input
                type="text"
                value={formData.nameFr}
                onChange={(e) => setFormData({ ...formData, nameFr: e.target.value })}
                className="w-full p-3 rounded-lg bg-card border border-border text-foreground focus:outline-none focus:ring-2 focus:ring-[#c74242]"
              />
            </div>

            <div>
              <label className="block text-sm mb-2">Product Name (Arabic)</label>
              <input
                type="text"
                value={formData.nameAr}
                onChange={(e) => setFormData({ ...formData, nameAr: e.target.value })}
                className="w-full p-3 rounded-lg bg-card border border-border text-foreground focus:outline-none focus:ring-2 focus:ring-[#c74242]"
              />
            </div>

            <div>
              <label className="block text-sm mb-2">Price *</label>
              <input
                type="number"
                step="0.01"
                value={formData.price}
                onChange={(e) => setFormData({ ...formData, price: e.target.value })}
                className="w-full p-3 rounded-lg bg-card border border-border text-foreground focus:outline-none focus:ring-2 focus:ring-[#c74242]"
              />
            </div>

            <div>
              <label className="block text-sm mb-2">Category *</label>
              <select
                value={formData.category}
                onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                className="w-full p-3 rounded-lg bg-card border border-border text-foreground focus:outline-none focus:ring-2 focus:ring-[#c74242]"
              >
                {categories.map((cat) => (
                  <option key={cat.id} value={cat.id} className="bg-card text-foreground">
                    {cat.name}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="block text-sm mb-2">Image URL</label>
              <input
                type="text"
                value={formData.image}
                onChange={(e) => setFormData({ ...formData, image: e.target.value })}
                className="w-full p-3 rounded-lg bg-card border border-border text-foreground focus:outline-none focus:ring-2 focus:ring-[#c74242]"
              />
            </div>

            <div className="flex gap-2 pt-4">
              <button
                onClick={() => setIsEditDialogOpen(false)}
                className="flex-1 py-3 border border-border rounded-lg hover:bg-muted transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={handleSubmitEdit}
                className="flex-1 py-3 bg-[#c74242] text-white rounded-lg hover:bg-[#c74242]/90 transition-colors"
              >
                Save Changes
              </button>
            </div>
          </div>
        </DialogContent>
      </Dialog>

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
