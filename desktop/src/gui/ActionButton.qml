import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

Button {
  id: button

  function handler() {}
  hoverEnabled: false

  font.bold: true

  property var notHoveredColor: "#0053A6"
  property var hoveredColor: "#0079F2"

  onClicked: handler()
  Keys.onReturnPressed: handler()
  Keys.onEnterPressed: handler()

  background: Rectangle {
    color: parent.visualFocus ? button.hoveredColor : button.notHoveredColor

    implicitWidth: 100
    implicitHeight: 40

    radius: 4

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      onEntered: parent.color = button.hoveredColor
      onExited: parent.color = button.notHoveredColor
    }
  }
}