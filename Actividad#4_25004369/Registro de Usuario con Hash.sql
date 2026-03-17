const router = require("express").Router()
const bcrypt = require("bcryptjs")
const jwt = require("jsonwebtoken")
const User = require("../models/User")

router.post("/register", async (req, res) => {

  const { email, password } = req.body

  const hash = await bcrypt.hash(password, 10)

  const user = new User({
    email,
    password: hash
  })

  await user.save()

  res.json({ message: "User created" })
})

router.post("/login", async (req, res) => {

  const { email, password } = req.body

  const user = await User.findOne({ email })

  if (!user) return res.status(404).json("User not found")

  const valid = await bcrypt.compare(password, user.password)

  if (!valid) return res.status(401).json("Invalid password")

  const token = jwt.sign({ id: user._id }, "secret")

  res.json({ token })

})

module.exports = router