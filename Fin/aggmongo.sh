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
