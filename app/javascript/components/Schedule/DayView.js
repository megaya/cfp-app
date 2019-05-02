import React from "react"
import PropTypes from "prop-types"
class DayView extends React.Component {
  render() {
    const { schedule, dayViewing, startTime, endTime } = this.props;
    let rows = schedule.rooms.map(room => {
      const height = (( endTime - startTime + 1) * 90 + 40) + 'px'
      const roomID = room.id;
      const thisRoomThisDaySlots = Object.values(schedule.slots[dayViewing.toString()]).find(room => room.find(slot => slot.room_id === roomID)) 

      const ripTime = time => {
        return parseInt(time.split("T")[1].split(":")[0]);
      }

      let slots = <React.Fragment></React.Fragment>;
      if (thisRoomThisDaySlots) {
        slots = thisRoomThisDaySlots.map(slot => {
          const slotStartTime = ripTime(slot.start_time);
          const slotEndTime = ripTime(slot.end_time);

          const style = {
            "top": ((slotStartTime - startTime) * 90) + 'px',
            "height": ((slotEndTime - slotStartTime) * 90) +'px'
          }

          return (
            <div className='schedule_slot' style={style}>

            </div>
          )
        })
      }

      return <div className='schedule_column' key={'column ' + room.name} style={{height}}>
        <div className='schedule_column_head'>{room.name}</div>
        <div className='schedule_time_slots'>
          {slots}
        </div>
      </div>
    })

    return (
      <React.Fragment>
        {rows}
      </React.Fragment>
    )
  }
}

DayView.propTypes = {
  schedule: PropTypes.object,
  dayViewing: PropTypes.number,
  startTime: PropTypes.number,
  endTime: PropTypes.number
}
DayView.defaultProps = {schedule: {rooms: []}}

export default DayView