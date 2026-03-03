const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
require("dotenv").config();

const authRoutes = require("./routes/authRoutes");
const habitRoutes = require("./routes/habitRoutes");

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/auth", authRoutes);
app.use("/api/habits", habitRoutes);

mongoose.connect(process.env.MONGO_URI)
.then(() => console.log("MongoDB Connected"))
.catch(err => console.log(err));

app.listen(5000, () => console.log("Server running on port 5000"));
const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  name: String,
  email: { type: String, unique: true },
  password: String,
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model("User", userSchema);
const mongoose = require("mongoose");

const habitSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  title: String,
  description: String,
  streak: { type: Number, default: 0 },
  lastCompletedDate: Date,
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model("Habit", habitSchema);
const jwt = require("jsonwebtoken");

module.exports = function(req, res, next) {
  const token = req.header("Authorization");

  if (!token) return res.status(401).json({ msg: "No token" });

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (err) {
    res.status(401).json({ msg: "Invalid token" });
  }
};
const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/User");

const router = express.Router();

router.post("/register", async (req, res) => {
  const { name, email, password } = req.body;

  const hashedPassword = await bcrypt.hash(password, 10);

  const user = new User({ name, email, password: hashedPassword });
  await user.save();

  res.json({ msg: "User registered" });
});

router.post("/login", async (req, res) => {
  const { email, password } = req.body;

  const user = await User.findOne({ email });
  if (!user) return res.status(400).json({ msg: "User not found" });

  const isMatch = await bcrypt.compare(password, user.password);
  if (!isMatch) return res.status(400).json({ msg: "Invalid credentials" });

  const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET);

  res.json({ token });
});

module.exports = router;
const express = require("express");
const Habit = require("../models/Habit");
const auth = require("../middleware/authMiddleware");

const router = express.Router();

router.post("/", auth, async (req, res) => {
  const habit = new Habit({
    userId: req.user.id,
    title: req.body.title,
    description: req.body.description
  });

  await habit.save();
  res.json(habit);
});

router.get("/", auth, async (req, res) => {
  const habits = await Habit.find({ userId: req.user.id });
  res.json(habits);
});

router.put("/:id/complete", auth, async (req, res) => {
  const habit = await Habit.findById(req.params.id);

  const today = new Date().toDateString();
  const last = habit.lastCompletedDate
    ? new Date(habit.lastCompletedDate).toDateString()
    : null;

  if (last !== today) {
    if (last && (new Date(today) - new Date(last)) > 86400000) {
      habit.streak = 0;
    }

    habit.streak += 1;
    habit.lastCompletedDate = new Date();
  }

  await habit.save();
  res.json(habit);
});

module.exports = router;
