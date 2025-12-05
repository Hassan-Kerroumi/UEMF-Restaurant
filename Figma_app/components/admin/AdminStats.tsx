import { useState } from 'react';
import { TrendingUp, Clock, Package, Users, Calendar as CalendarIcon } from 'lucide-react';
import { useApp } from '../../contexts/AppContext';
import { mockOrders, products } from '../../data/mockData';
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
  LineChart,
  Line,
  Legend,
} from 'recharts';

export function AdminStats() {
  const { t } = useApp();
  const [timePeriod, setTimePeriod] = useState<'month' | 'year'>('month');
  const [selectedMonth, setSelectedMonth] = useState('11');
  const [selectedYear, setSelectedYear] = useState('2025');

  // Mock data for monthly revenue
  const monthlyRevenueData = [
    { month: 'Jan', revenue: 4200, customers: 85 },
    { month: 'Feb', revenue: 3800, customers: 78 },
    { month: 'Mar', revenue: 5100, customers: 102 },
    { month: 'Apr', revenue: 4900, customers: 98 },
    { month: 'May', revenue: 5400, customers: 108 },
    { month: 'Jun', revenue: 4600, customers: 92 },
    { month: 'Jul', revenue: 3200, customers: 64 },
    { month: 'Aug', revenue: 3500, customers: 70 },
    { month: 'Sep', revenue: 5800, customers: 116 },
    { month: 'Oct', revenue: 6100, customers: 122 },
    { month: 'Nov', revenue: 5900, customers: 118 },
    { month: 'Dec', revenue: 4800, customers: 96 },
  ];

  const yearlyRevenueData = [
    { year: '2020', revenue: 42000, customers: 840 },
    { year: '2021', revenue: 48500, customers: 970 },
    { year: '2022', revenue: 54200, customers: 1084 },
    { year: '2023', revenue: 59800, customers: 1196 },
    { year: '2024', revenue: 63400, customers: 1268 },
    { year: '2025', revenue: 58600, customers: 1172 },
  ];

  // Calculate statistics
  const todayOrders = mockOrders.filter(order => order.date === '2025-11-09');
  const totalOrders = todayOrders.length;
  const totalRevenue = todayOrders.reduce((sum, order) => {
    return sum + order.items.reduce((itemSum, item) => 
      itemSum + (item.product.price * item.quantity), 0
    );
  }, 0);

  const revenueData = timePeriod === 'month' ? monthlyRevenueData : yearlyRevenueData;
  const periodLabel = timePeriod === 'month' ? 'Month' : 'Year';

  // Most ordered items
  const itemCounts = todayOrders.reduce((acc, order) => {
    order.items.forEach(item => {
      const key = item.product.name;
      acc[key] = (acc[key] || 0) + item.quantity;
    });
    return acc;
  }, {} as Record<string, number>);

  const mostOrdered = Object.entries(itemCounts)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 5)
    .map(([name, count]) => ({ name, count }));

  // Orders by time
  const ordersByTime = todayOrders.reduce((acc, order) => {
    const hour = parseInt(order.pickupTime.split(':')[0]);
    const timeRange = `${hour}:00`;
    acc[timeRange] = (acc[timeRange] || 0) + 1;
    return acc;
  }, {} as Record<string, number>);

  const timeData = Object.entries(ordersByTime)
    .map(([time, count]) => ({ time, orders: count }))
    .sort((a, b) => a.time.localeCompare(b.time));

  // Order status distribution
  const statusData = [
    { name: 'Pending', value: mockOrders.filter(o => o.status === 'pending').length, color: '#f59e0b' },
    { name: 'Confirmed', value: mockOrders.filter(o => o.status === 'confirmed').length, color: '#3b82f6' },
    { name: 'Paid', value: mockOrders.filter(o => o.status === 'paid').length, color: '#3cad2a' },
    { name: 'Cancelled', value: mockOrders.filter(o => o.status === 'cancelled').length, color: '#ef4444' },
  ];

  // Average wait time (mock calculation)
  const avgWaitTime = 15; // minutes

  return (
    <div className="pb-20 pt-16 px-4">
      <div className="flex items-center justify-between mb-6">
        <h2 className="text-[#c74242]">{t('stats')}</h2>
        <div className="flex gap-2">
          <button
            onClick={() => setTimePeriod('month')}
            className={`px-4 py-2 rounded-lg transition-colors ${
              timePeriod === 'month'
                ? 'bg-[#c74242] text-white'
                : 'bg-card border border-border hover:bg-muted'
            }`}
          >
            Month
          </button>
          <button
            onClick={() => setTimePeriod('year')}
            className={`px-4 py-2 rounded-lg transition-colors ${
              timePeriod === 'year'
                ? 'bg-[#c74242] text-white'
                : 'bg-card border border-border hover:bg-muted'
            }`}
          >
            Year
          </button>
        </div>
      </div>

      {/* Key Metrics */}
      <div className="grid grid-cols-2 gap-4 mb-6">
        <div className="bg-gradient-to-br from-[#062c6b] to-[#0a4099] text-white p-4 rounded-xl shadow-md">
          <div className="flex items-center gap-2 mb-2">
            <Package size={20} />
            <p className="text-sm opacity-90">{t('totalOrders')}</p>
          </div>
          <p className="text-3xl">{totalOrders}</p>
          <p className="text-xs opacity-75 mt-1">Today</p>
        </div>

        <div className="bg-gradient-to-br from-[#3cad2a] to-[#2d8a20] text-white p-4 rounded-xl shadow-md">
          <div className="flex items-center gap-2 mb-2">
            <TrendingUp size={20} />
            <p className="text-sm opacity-90">Revenue</p>
          </div>
          <p className="text-3xl">${totalRevenue.toFixed(0)}</p>
          <p className="text-xs opacity-75 mt-1">Today</p>
        </div>

        <div className="bg-gradient-to-br from-[#c74242] to-[#a53535] text-white p-4 rounded-xl shadow-md">
          <div className="flex items-center gap-2 mb-2">
            <Clock size={20} />
            <p className="text-sm opacity-90">{t('avgWaitTime')}</p>
          </div>
          <p className="text-3xl">{avgWaitTime}m</p>
          <p className="text-xs opacity-75 mt-1">Average</p>
        </div>

        <div className="bg-gradient-to-br from-[#8b5cf6] to-[#7c3aed] text-white p-4 rounded-xl shadow-md">
          <div className="flex items-center gap-2 mb-2">
            <Users size={20} />
            <p className="text-sm opacity-90">Active Users</p>
          </div>
          <p className="text-3xl">42</p>
          <p className="text-xs opacity-75 mt-1">Today</p>
        </div>
      </div>

      {/* Revenue & Customers Trends */}
      <div className="bg-card rounded-xl p-4 shadow-md border border-border mb-6">
        <h3 className="mb-4">Revenue & Customer Trends ({periodLabel})</h3>
        <ResponsiveContainer width="100%" height={250}>
          <LineChart data={revenueData}>
            <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.1)" />
            <XAxis 
              dataKey={timePeriod === 'month' ? 'month' : 'year'} 
              stroke="currentColor" 
              fontSize={12} 
            />
            <YAxis stroke="currentColor" fontSize={12} />
            <Tooltip 
              contentStyle={{ 
                backgroundColor: 'var(--card)', 
                border: '1px solid var(--border)',
                borderRadius: '8px',
              }} 
            />
            <Legend />
            <Line 
              type="monotone" 
              dataKey="revenue" 
              stroke="#3cad2a" 
              strokeWidth={2}
              name="Revenue ($)"
            />
            <Line 
              type="monotone" 
              dataKey="customers" 
              stroke="#062c6b" 
              strokeWidth={2}
              name="Customers"
            />
          </LineChart>
        </ResponsiveContainer>
      </div>

      {/* Most Ordered Items */}
      <div className="bg-card rounded-xl p-4 shadow-md border border-border mb-6">
        <h3 className="mb-4">{t('mostOrdered')}</h3>
        <div className="space-y-3">
          {mostOrdered.map((item, index) => {
            const product = products.find(p => p.name === item.name);
            return (
              <div key={item.name} className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-[#c74242]/10 text-[#c74242] flex items-center justify-center">
                  {index + 1}
                </div>
                {product && (
                  <img
                    src={product.image}
                    alt={item.name}
                    className="w-12 h-12 rounded-lg object-cover"
                  />
                )}
                <div className="flex-1">
                  <p className="text-sm">{item.name}</p>
                  <p className="text-xs text-muted-foreground">{item.count} orders</p>
                </div>
                <div className="w-20 h-2 bg-muted rounded-full overflow-hidden">
                  <div
                    className="h-full bg-[#c74242]"
                    style={{ width: `${(item.count / mostOrdered[0].count) * 100}%` }}
                  />
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* Orders by Time Chart */}
      <div className="bg-card rounded-xl p-4 shadow-md border border-border mb-6">
        <h3 className="mb-4">Orders by Time</h3>
        <ResponsiveContainer width="100%" height={200}>
          <BarChart data={timeData}>
            <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.1)" />
            <XAxis dataKey="time" stroke="currentColor" fontSize={12} />
            <YAxis stroke="currentColor" fontSize={12} />
            <Tooltip 
              contentStyle={{ 
                backgroundColor: 'var(--card)', 
                border: '1px solid var(--border)',
                borderRadius: '8px',
              }} 
            />
            <Bar dataKey="orders" fill="#c74242" radius={[8, 8, 0, 0]} />
          </BarChart>
        </ResponsiveContainer>
      </div>

      {/* Order Status Distribution */}
      <div className="bg-card rounded-xl p-4 shadow-md border border-border">
        <h3 className="mb-4">Order Status Distribution</h3>
        <ResponsiveContainer width="100%" height={250}>
          <PieChart>
            <Pie
              data={statusData}
              cx="50%"
              cy="50%"
              labelLine={false}
              label={({ name, percent }) => `${name} ${(percent * 100).toFixed(0)}%`}
              outerRadius={80}
              fill="#8884d8"
              dataKey="value"
            >
              {statusData.map((entry, index) => (
                <Cell key={`cell-${index}`} fill={entry.color} />
              ))}
            </Pie>
            <Tooltip 
              contentStyle={{ 
                backgroundColor: 'var(--card)', 
                border: '1px solid var(--border)',
                borderRadius: '8px',
              }} 
            />
          </PieChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}
