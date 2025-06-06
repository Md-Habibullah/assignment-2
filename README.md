# assignment-2

# question 1:
## What is PostgreSQL?

PostgteSQL হচ্ছে একটি Database Management System। এটি সবচেয়ে Advance SQL ল্যাংগুয়েজ গুলোর মধ্যে একটি। postgreSQL ডাটা সংরক্ষণ, ম্যানেজমেন্ট এবং তথ্য সহজে এনালাইসিস করার জন্য ব্যবহার করা হয়।



### PostgreSQL এর Features সমূহঃ

postgreSQL একটি Open Source এবং ফ্রী হওয়ায় এর Community Support বেশি। Cross Platform যেমন windows, mac, linux সবখানে ব্যবহার করা যায়।  এটি SQL এবং JSON দুটিই সাপোর্ট করে।  postgreSQL একটি Declarative ল্যাংগুয়েজ হলেও এটিতে Function বা Procedure ব্যবহার করে Procedural way তে ব্যবহার করা যায়। এটিতে কোয়েরী ইনডেক্সিং করে রাখা যায় যার ফলে Data অনেক দ্রুত Read করা যায়।



### ব্যাবহারঃ

আমরা PostgreSQL কে Local Machine এ install করে নিজেদের লোকাল স্টোরেজকে একটি ডাটাবেজ বানিয়ে ফেলতে পারি। এবং অনেক সহজে ডাটাবেসটি মেনেজ করতে পারি।

তার জন্য PostgreSQL এর অফিশিয়াল সাইট থেকে এর installed ফাইল ডাউনলোড করতে হবে। তারপরে লোকালহোস্ট 5432 এ এটিকে কানেক্ট করতে হবে। এবং PgAdmin এ গিয়ে ডাটাবেজ login করতে হবে।




# question 2:

## What is Primary key?

Primary key হচ্ছে একটি Field বা একাধিক Field-এর কম্বিনেশন যা একটি Row বা Record কে ইউনিকভাবে শনাক্ত করে। Primary key প্রতিটি টেবিলে ১টি-ই থাকে এবং এটি Null Value হতে পারেনা।


```sql
CREATE TABLE Employee (
    employee_id SERIAL PRIMARY KEY,
    employee_name VARCHAR(50),
    age INTEGER
);
```



## What is Foreign key?

Foreign কি এমন একটি কলাম যা অন্য টেবিলের Primary key কে রেফার করে। যার সাহায্যে যেই টেবিলের সাথে লিংক করা যায় এবং একটি Foreign key দিয়েই সেই পুরো টেবিলের ডাটা read করা যায়।


```sql
CREATE TABLE Project (
    project_id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employee(employee_id),
    project_name VARCHAR(50)
);
```


Primary key প্রতিটি row কে uniquely identify করে যা প্রতি টেবিলে একটিই থাকে। এবং Foreign key একটি টেবিলে অপর টেবিলের সাথে লিংক করার জন্য ব্যবহার করা হয়। একটি টেবিলে একধিক Foreign key থাকতে পারে।


# question 3:

GROUP BY এর সাহায্যে মূলত কলামের একই ধরনের record গুলো নিয়ে একত্রে গ্রুপিং করা হয়। এর উদ্দেশ্য হচ্ছে যাতে একই জাতীয় প্রত্যেকটি Field এর উপর আলাদা আলাদা ভাবে Aggregate ফাংশন run করা যায়।

যেমন: মনে করি স্কুলের একটি শ্রেণীতে ৩টি শাখা রয়েছে 'ক', 'খ' এবং 'গ'। এবং প্রত্যেকটি শাখাতে কতজন শিক্ষার্থী রয়েছে সেই ডাটা Retrieve করতে হবে।

example :
```sql
SELECT section, COUNT(*) AS total_students_in_section
FROM students
GROUP BY section;
```

### Role in aggregation operations:

এরকম আরো অনেক সিনারিওতে গ্রুপগুলো নিয়ে count() এর পাশাপাশি sum(), avg(), min(), max() ইত্যাদি অপারেশন ইমপ্লিমেন্টের প্রয়োজন পরে। তখন GROUP BY ব্যবহার করে এসব সহজেই করে ফেলা যায়।

examples:
```sql
SELECT section, SUM(marks) AS total_marks_in_section
FROM students
GROUP BY section;
```

এটির সাহায্য প্রতিটি সেকশনের জন্য সব শিক্ষার্থীর মোট Marks এর যোগফল দেখাবে।
```sql
SELECT section, AVG(marks) AS average_marks_in_section
FROM students
GROUP BY section;
```

এবং এভাবে প্রতিটি সেকশনে শিক্ষার্থীদের Marks এর avarage বের করা যাবে।


# question 4:

SELECT statement এর WHERE  clause ব্যবহার করে কোনো নির্দিষ্ট শর্ত বা condition এর উপর ভিত্তি করে ডাটা ফিল্টার করা হয়। এটির মূল কাজ হচ্ছে আপনার যেই ডাটাগুলো দরকার, নির্দিষ্ট শর্তের উপর ভিত্তি করে সেই ডাটা গুলো retrieve করতে পারবেন।

example:

```sql
SELECT name, age
    FROM Mentors
    WHERE age > 25;
```

এখানে একটি নির্দিষ্ট শর্ত Age এর উপর ভিত্তি করে ফিল্টার করা হয় ফলে শুধুমাত্র যেসব মেন্টরদের বয়স ২৫ এর বেশি তাদের নাম এবং বয়স ই retrieve করা হয়েছে। তাই এটি অত্যন্ত গুরুত্বপূর্ণ একটা Clause যা ছাড়া প্রয়োজনীয় ডাটা retrieve


# question 5:

কোনো নির্দিষ্ট সংখ্যক Row এর Data retrieve করতে LIMIT এবং কতগুলো Row skip করে তারপরে গিয়ে retrieve করবে সেটা বলে দেওয়ার কাজ করে OFFSET। এটি মূলত Pagination এর জন্য বেশি ব্যবহৃত হয়। যেমন: যদি বলা হয় LIMIT 10 OFFSET 10 তাহলে টেবিলের প্রথম ১০ টি রো এর ডাটা skip করে পরের ১০ টি রো এর ডাটা বের করে আনবে।

example:

```sql
SELECT * FROM products
    ORDER BY product_id
    LIMIT 10 OFFSET 10*0;
```

for retrieve the first page's 10 data


```sql
SELECT * FROM products
    ORDER BY product_id
    LIMIT 10 OFFSET 10*1;
```


for retrieve the second pages 10 data.


