export default function ProgressBar({ days }) {

  const percentage = (days / 66) * 100

  const color = days < 33 ? "red" : days < 50 ? "orange" : "green"

  return (

    <div style={{
      width: "100%",
      background: "#ddd",
      height: "20px"
    }}>

      <div style={{
        width: percentage + "%",
        height: "100%",
        background: color
      }}></div>

    </div>

  )
}