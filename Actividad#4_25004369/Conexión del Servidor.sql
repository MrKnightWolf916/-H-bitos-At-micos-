const express = require("express")
const mongoose = require("mongoose")
const cors = require("cors")

const authRoutes = require("./routes/auth")
const habitRoutes = require("./routes/habits")

const app = express()

app.use(cors())
app.use(express.json())

mongoose.connect("mongodb://localhost:27017/habits")

app.use("/api/auth", authRoutes)
app.use("/api/habits", habitRoutes)

app.listen(5000, () => {
  console.log("Server running on port 5000")
})