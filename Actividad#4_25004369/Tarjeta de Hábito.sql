import ProgressBar from "./ProgressBar"

export default function HabitCard({ habit, refresh }) {

  const doneHabit = async () => {

    await fetch(`http://localhost:5000/api/habits/done/${habit._id}`, {
      method: "POST"
    })

    refresh()
  }

  return (

    <div>

      <h3>{habit.name}</h3>

      <p>Streak: {habit.streak} days</p>

      <ProgressBar days={habit.streak} />

      <button onClick={doneHabit}>
        Done
      </button>

    </div>

  )

}