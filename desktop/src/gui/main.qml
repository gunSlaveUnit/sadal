import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Qt.labs.platform as Platform

ApplicationWindow {
  id: window
  width: 1000
  height: 500
  visible: true
  title: windowTitle
  color: backgroundWindowColor

  property string backgroundWindowColor: "#212834"
  property string highlightedTextColor: "#0079F2"
  property string windowTitle: qsTr("foggie")
  property int defaultMargin: 8

  menuBar: MenuBar {
    id: menu
    visible: false

    background: Rectangle {
      color: "transparent"
    }

    Menu {
      title: qsTr('Foggie')

      Action {
        text: qsTr("Store")
      }

      Action {
        text: qsTr("Library")
      }

      Action {
        text: qsTr("Workroom")
        onTriggered: storeStackLayout.checkCompanyRegistration()
      }
    }

    Menu {
      title: qsTr('Nickname')
      Action {text: qsTr("Profile")}
      Action {text: qsTr("Wallet")}
      Action {text: qsTr("Cart")}
      Action {text: qsTr("Settings")}
      Action {
        text: qsTr("Logout")
        onTriggered: auth_logic.sign_out()
      }
    }
  }

  StackLayout {
    id: mainStackLayout

    anchors.fill: parent

    property int authorizationSectionIndex: 0
    property int storeSectionIndex: 1

    StackLayout {
			id: authStackLayout

      anchors.fill: parent

			Connections {
				target: auth_logic

				function onRegistered() {
					mainStackLayout.currentIndex = mainStackLayout.storeSectionIndex
					menu.visible = true
				}

		    function onLogin() {
					mainStackLayout.currentIndex = mainStackLayout.storeSectionIndex
					menu.visible = true
		    }
			}

	    property int signInFormIndex: 0
	    property int signUpFormIndex: 1

	    Item {
	      anchors.margins: defaultMargin
	      Layout.preferredWidth: window.width
	      Layout.preferredHeight: window.height

	      ColumnLayout {
          id: signInForm
          anchors.centerIn: parent

          FormInputLabel {
            text: qsTr("ACCOUNT NAME")
            color: highlightedTextColor
          }
          FormInput {
            id: signInAccountNameInput
            focus: true
            text: auth_logic.account_name
            onTextChanged: auth_logic.account_name = text
          }

          Indent {}

          FormInputLabel {text: qsTr("PASSWORD")}
          FormInput {
            echoMode: TextInput.Password
            text: auth_logic.password
            onTextChanged: auth_logic.password = text
          }

          Indent {}

          ActionButton {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Sign in")

            function handler() {
              auth_logic.sign_in()
            }
          }

          Indent {}

          RowLayout {
            Layout.alignment: Qt.AlignHCenter

            Span {text: qsTr("Need an account?")}

            Link {
              message: qsTr("Sign up")

              function handler() {
                auth_logic.reset()
                signUpEmailInput.focus = true
                authStackLayout.currentIndex = authStackLayout.signUpFormIndex
              }
            }
          }
        }
	    }

      Item {
        anchors.margins: defaultMargin
	      Layout.preferredWidth: window.width
	      Layout.preferredHeight: window.height

	      ColumnLayout {
          id: signUpForm
          anchors.centerIn: parent

          FormInputLabel {text: qsTr("EMAIL")}
          FormInput {
            id: signUpEmailInput
            text: auth_logic.email
            onTextChanged: auth_logic.email = text
          }

          Indent {}

          FormInputLabel {text: qsTr("ACCOUNT NAME")}
          FormInput {
            text: auth_logic.account_name
            onTextChanged: auth_logic.account_name = text
          }

          Indent {}

          FormInputLabel {text: qsTr("PASSWORD")}
          FormInput {
            echoMode: TextInput.Password
            text: auth_logic.password
            onTextChanged: auth_logic.password = text
          }

          Indent {}

          ActionButton {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Sign up")

            function handler() {
              auth_logic.sign_up()
            }
          }

          Indent {}

          RowLayout {
            Layout.alignment: Qt.AlignHCenter

            Span {text: qsTr("Already have an account?")}

            Link {
              message: qsTr("Sign in")

              function handler() {
                auth_logic.reset()
                signInAccountNameInput.focus = true
                authStackLayout.currentIndex = authStackLayout.signInFormIndex
              }
            }
          }
        }
      }
    }

    StackLayout {
      id: storeStackLayout

      property int workshopRegisterCompanyInfoIndex: 0
      property int workshopRegisterPaymentInfoIndex: workshopRegisterCompanyInfoIndex + 1
      property int workshopAppsListIndex: workshopRegisterPaymentInfoIndex + 1
      property int workshopAppControlIndex: workshopAppsListIndex + 1

      function checkCompanyRegistration() {
        company_logic.check()
      }

      Connections {
        target: company_logic

        function onNotRegistered() {
          storeStackLayout.currentIndex = storeStackLayout.workshopRegisterCompanyInfoIndex
        }

        function onRegistered() {
          storeStackLayout.currentIndex = storeStackLayout.workshopAppsListIndex
        }
      }

      Connections {
        target: auth_logic

        function onRegistered() {
          game_list_model.load_store()
        }

        function onLogin() {
          game_list_model.load_store()
        }

        function onLogout() {
          menu.visible = false

          authStackLayout.currentIndex = authStackLayout.signInFormIndex
          mainStackLayout.currentIndex = mainStackLayout.authorizationSectionIndex
          storeStackLayout.currentIndex = storeStackLayout.storeGamesIndex
        }
      }

      Scroll {
        contentHeight: companyInfoForm.height

        Item {
          width: parent.width * 0.8
          anchors.horizontalCenter: parent.horizontalCenter

          ColumnLayout {
            id: companyInfoForm

            Indent {}

            FormInputLabel {
              text: qsTr("Juridical name")
            }
            FormInput {
              id: juridicalNameInput
              focus: true
              text: company_logic.juridical_name
              onTextChanged: company_logic.juridical_name = text
            }

            Indent {}

            FormInputLabel {
              text: qsTr("Company form")
            }
            FormInput {
              text: company_logic.company_form
              onTextChanged: company_logic.company_form = text
            }

            Indent {}

            FormInputLabel {
              text: qsTr("Street, house and apartment/office number")
            }
            FormInput {
              text: company_logic.street_house_apartment
              onTextChanged: company_logic.street_house_apartment = text
            }

            Indent {}

            FormInputLabel {
              text: qsTr("City")
            }
            FormInput {
              text: company_logic.city
              onTextChanged: company_logic.city = text
            }

            Indent {}

            FormInputLabel {
              text: qsTr("Region")
            }
            FormInput {
              text: company_logic.region
              onTextChanged: company_logic.region = text
            }

            Indent {}

            FormInputLabel {
              text: qsTr("Country")
            }
            FormInput {
              text: company_logic.country
              onTextChanged: company_logic.country = text
            }

            Indent {}

            FormInputLabel {
              text: qsTr("Postal code")
            }
            FormInput {
              text: company_logic.postal_code
              onTextChanged: company_logic.postal_code = text
            }

            Indent {}

            FormInputLabel {
              text: qsTr("Notification email")
            }
            FormInput {
              text: company_logic.notification_email
              onTextChanged: company_logic.notification_email = text
            }

            Indent {}

            NeutralButton {
              text: qsTr("Next")
              function handler() {
                bicInput.focus = true
                storeStackLayout.currentIndex = storeStackLayout.workshopRegisterPaymentInfoIndex
              }
            }

            Indent {}
          }
        }
      }

      Scroll {
        contentHeight: companyPayInfoForm.height

        Item {
          width: parent.width * 0.8
          anchors.horizontalCenter: parent.horizontalCenter

          ColumnLayout {
            id: companyPayInfoForm

            Indent {}

            Link {
              message: qsTr("To company information")

              function handler() {
                juridicalNameInput.focus = true
                storeStackLayout.currentIndex = storeStackLayout.workshopRegisterCompanyInfoIndex
              }
            }

            Indent {}

            FormInputLabel {
              text: qsTr("BIC")
            }
            FormInput {
              id: bicInput
              focus: true
              text: company_logic.bic
              onTextChanged: company_logic.bic = text
            }

            Indent {}

            FormInputLabel {
              text: qsTr("Bank address")
            }
            FormInput {
              text: company_logic.bank_address
              onTextChanged: company_logic.bank_address = text
            }

            Indent {}

            FormInputLabel {
              text: qsTr("Bank account number")
            }
            FormInput {
              text: company_logic.bank_account_number
              onTextChanged: company_logic.bank_account_number = text
            }

            Indent {}

            ActionButton {
              text: qsTr("Finish")
              function handler() {
                company_logic.new()
              }
            }

            Indent {}
          }
        }
      }

      Scroll {
        contentHeight: releasesAppsList.height

        Item {
          width: parent.width * 0.8
          anchors.horizontalCenter: parent.horizontalCenter

          ColumnLayout {
            id: releasesAppsList

            Header {
              text: "Bruh"
            }
          }
        }
      }
    }
  }
}