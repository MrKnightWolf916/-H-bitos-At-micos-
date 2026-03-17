import { useEffect, useState } from "react"
import HabitCard from "../components/HabitCard"

export default function Dashboard() {

  const [habits, setHabits] = useState([])

  const loadHabits = async () => {

    const res = await fetch(
      "http://localhost:5000/api/habits?userId=123"
    )

    const data = await res.json()

    setHabits(data)

  }

  useEffect(() => {
    loadHabits()
  }, [])

  return (

    <div>

      <h1>My Habits</h1>

      {habits.map(habit => (
        <HabitCard
          key={habit._id}
          habit={habit}
          refresh={loadHabits}
        />
      ))}

    </div>

  )

}