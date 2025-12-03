db.books.aggregate([
  { $sort: { price: -1 } },
  { 
    $group: { 
      _id: "$category",
      mostExpensiveBook: { $first: "$title" },
      price: { $first: "$price" }
    }
  }
]);


db.books.aggregate([
  { $group: { _id: "$category", totalBooks: { $sum: 1 } } }
]);

