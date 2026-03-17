const router = require("express").Router()
const Habit = require("../models/Habit")

router.post("/", async (req, res) => {

  const habit = new Habit(req.body)
  await habit.save()

  res.json(habit)
})

router.get("/", async (req, res) => {

  const habits = await Habit.find({ userId: req.query.userId })

  res.json(habits)
})

router.post("/done/:id", async (req, res) => {

  const habit = await Habit.findById(req.params.id)

  const today = new Date()
  const last = habit.lastCompleted

  if (!last) {
    habit.streak += 1
  } else {

    const diff = Math.floor(
      (today - last) / (1000 * 60 * 60 * 24)
    )

    if (diff === 1) {
      habit.streak += 1
    } else if (diff > 1) {
      habit.streak = 1
    }

  }

  habit.lastCompleted = today

  await habit.save()

  res.json(habit)

})

module.exports = router