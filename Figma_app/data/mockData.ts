export interface Product {
  id: string;
  name: string;
  nameAr: string;
  nameFr: string;
  price: number;
  category: string;
  image: string;
  description?: string;
}

export interface Order {
  id: string;
  studentName: string;
  items: {
    product: Product;
    quantity: number;
  }[];
  pickupTime: string;
  status: 'pending' | 'confirmed' | 'paid' | 'cancelled' | 'accepted' | 'refused';
  type: 'takeaway' | 'eatin';
  date: string;
}

export const categories = [
  { id: 'hot-drinks', name: 'Hot Drinks', nameFr: 'Boissons chaudes', nameAr: 'مشروبات ساخنة' },
  { id: 'cold-drinks', name: 'Cold Drinks', nameFr: 'Boissons froides', nameAr: 'مشروبات باردة' },
  { id: 'cakes-desserts', name: 'Cakes & Desserts', nameFr: 'Gâteaux & desserts', nameAr: 'كعك وحلويات' },
  { id: 'breakfast', name: 'Breakfast', nameFr: 'Petit déjeuner', nameAr: 'فطور' },
  { id: 'pizza-pasta', name: 'Pizza & Pasta', nameFr: 'Pizza & pâtes', nameAr: 'بيتزا ومعكرونة' },
  { id: 'dishes', name: 'Main Dishes', nameFr: 'Plats', nameAr: 'أطباق رئيسية' },
  { id: 'sandwiches', name: 'Sandwiches', nameFr: 'Sandwiches', nameAr: 'ساندويتشات' },
  { id: 'salads', name: 'Salads', nameFr: 'Salades', nameAr: 'سلطات' },
  { id: 'dairy', name: 'Dairy', nameFr: 'Laitage', nameAr: 'ألبان' },
  { id: 'snacks', name: 'Snacks', nameFr: 'Snacks', nameAr: 'وجبات خفيفة' },
];

export const products: Product[] = [
  {
    id: '1',
    name: 'Espresso',
    nameFr: 'Espresso',
    nameAr: 'إسبريسو',
    price: 2.50,
    category: 'hot-drinks',
    image: 'https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?w=400',
  },
  {
    id: '2',
    name: 'Cappuccino',
    nameFr: 'Cappuccino',
    nameAr: 'كابتشينو',
    price: 3.50,
    category: 'hot-drinks',
    image: 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400',
  },
  {
    id: '3',
    name: 'Fresh Orange Juice',
    nameFr: 'Jus d\'orange frais',
    nameAr: 'عصير برتقال طازج',
    price: 4.00,
    category: 'cold-drinks',
    image: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400',
  },
  {
    id: '4',
    name: 'Iced Tea',
    nameFr: 'Thé glacé',
    nameAr: 'شاي مثلج',
    price: 2.50,
    category: 'cold-drinks',
    image: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400',
  },
  {
    id: '5',
    name: 'Chocolate Cake',
    nameFr: 'Gâteau au chocolat',
    nameAr: 'كعكة الشوكولاتة',
    price: 5.00,
    category: 'cakes-desserts',
    image: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
  },
  {
    id: '6',
    name: 'Croissant',
    nameFr: 'Croissant',
    nameAr: 'كرواسون',
    price: 2.00,
    category: 'breakfast',
    image: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400',
  },
  {
    id: '7',
    name: 'Margherita Pizza',
    nameFr: 'Pizza Margherita',
    nameAr: 'بيتزا مارغريتا',
    price: 8.50,
    category: 'pizza-pasta',
    image: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400',
  },
  {
    id: '8',
    name: 'Spaghetti Carbonara',
    nameFr: 'Spaghetti Carbonara',
    nameAr: 'سباغيتي كاربونارا',
    price: 9.00,
    category: 'pizza-pasta',
    image: 'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=400',
  },
  {
    id: '9',
    name: 'Grilled Chicken',
    nameFr: 'Poulet grillé',
    nameAr: 'دجاج مشوي',
    price: 12.00,
    category: 'dishes',
    image: 'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=400',
  },
  {
    id: '10',
    name: 'Beef Burger',
    nameFr: 'Burger au bœuf',
    nameAr: 'برجر لحم',
    price: 10.00,
    category: 'sandwiches',
    image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
  },
  {
    id: '11',
    name: 'Caesar Salad',
    nameFr: 'Salade César',
    nameAr: 'سلطة سيزر',
    price: 7.50,
    category: 'salads',
    image: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400',
  },
  {
    id: '12',
    name: 'Yogurt',
    nameFr: 'Yaourt',
    nameAr: 'زبادي',
    price: 2.00,
    category: 'dairy',
    image: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400',
  },
  {
    id: '13',
    name: 'French Fries',
    nameFr: 'Frites',
    nameAr: 'بطاطس مقلية',
    price: 3.50,
    category: 'snacks',
    image: 'https://images.unsplash.com/photo-1576107232684-1279f390859f?w=400',
  },
  {
    id: '14',
    name: 'Cheese Pizza',
    nameFr: 'Pizza au fromage',
    nameAr: 'بيتزا جبن',
    price: 9.00,
    category: 'pizza-pasta',
    image: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
  },
  {
    id: '15',
    name: 'Club Sandwich',
    nameFr: 'Club Sandwich',
    nameAr: 'كلوب ساندويتش',
    price: 8.00,
    category: 'sandwiches',
    image: 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=400',
  },
];

export const mockOrders: Order[] = [
  {
    id: '1',
    studentName: 'Ahmed Ali',
    items: [
      { product: products[6], quantity: 1 },
      { product: products[1], quantity: 1 },
    ],
    pickupTime: '12:30',
    status: 'pending',
    type: 'eatin',
    date: '2025-11-09',
  },
  {
    id: '2',
    studentName: 'Sara Ben',
    items: [
      { product: products[9], quantity: 2 },
      { product: products[12], quantity: 2 },
    ],
    pickupTime: '13:00',
    status: 'confirmed',
    type: 'takeaway',
    date: '2025-11-09',
  },
  {
    id: '3',
    studentName: 'Mohamed Kadi',
    items: [
      { product: products[10], quantity: 1 },
    ],
    pickupTime: '12:15',
    status: 'paid',
    type: 'eatin',
    date: '2025-11-08',
  },
  {
    id: '4',
    studentName: 'Leila Hassan',
    items: [
      { product: products[7], quantity: 1 },
      { product: products[3], quantity: 1 },
    ],
    pickupTime: '14:00',
    status: 'pending',
    type: 'takeaway',
    date: '2025-11-09',
  },
  {
    id: '5',
    studentName: 'Youssef Amin',
    items: [
      { product: products[8], quantity: 1 },
    ],
    pickupTime: '13:30',
    status: 'accepted',
    type: 'eatin',
    date: '2025-11-09',
  },
];

export const tomorrowSuggestions: Product[] = [
  products[6],
  products[7],
  products[8],
  products[9],
  products[10],
];
