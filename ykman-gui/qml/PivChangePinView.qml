import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import QtQuick.Controls.Material 2.2

ChangePinView {

    breadcrumbs: [{
            text: qsTr("PIV")
        }, {
            text: qsTr("Configure PINs")
        }, {
            text: qsTr("PIN")
        }]
    defaultCurrentPin: constants.pivDefaultPin
    hasCurrentPin: true
    maxLength: constants.pivPinMaxLength
    minLength: constants.pivPinMinLength

    onChangePin: {
        yubiKey.pivChangePin(currentPin, newPin, function (resp) {
            if (resp.success) {
                pivSuccessPopup.open()
                views.pop()
            } else {
                pivError.showResponseError(
                    resp,
                    qsTr("PIN change failed for an unknown reason. Error message: %1"),
                    qsTr("PIN change failed for an unknown reason."),
                    {
                        wrong_pin: qsTr("Wrong current PIN. Tries remaining: %1").arg(resp.tries_left),
                        blocked: qsTr("PIN is blocked. Use the PUK to unlock it, or reset the PIV application."),
                        incorrect_parameters: qsTr("Invalid PIN format. PIN must be %1 to %2 characters.").arg(minLength).arg(maxLength),
                    }
                )

                if (resp.error === 'wrong_pin') {
                    clearCurrentPinInput()
                } else if (resp.error === 'blocked') {
                    views.pop()
                } else if (resp.error === 'incorrect_parameters') {
                    clearNewPinInputs()
                }
            }
        })
    }
}
