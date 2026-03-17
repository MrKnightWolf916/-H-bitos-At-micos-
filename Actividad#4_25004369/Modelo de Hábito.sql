const mongoose = require("mongoose")

const HabitSchema = new mongoose.Schema({
  name: String,
  userId: String,
  streak: {
    type: Number,
    default: 0
  },
  lastCompleted: Date
})

module.exports = mongoose.model("Habit", HabitSchema)