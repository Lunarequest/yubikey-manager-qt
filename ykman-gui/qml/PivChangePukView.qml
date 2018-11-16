import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import QtQuick.Controls.Material 2.2

ChangePinView {

    breadcrumbs: [{
            text: qsTr("PUK")
        }, {
            text: qsTr("Configure PINs")
        }, {
            text: qsTr("PUK")
        }]
    codeName: qsTr("PUK")
    defaultCurrentPin: constants.pivDefaultPuk
    hasCurrentPin: true
    maxLength: constants.pivPukMaxLength
    minLength: constants.pivPukMinLength

    onChangePin: {
        yubiKey.pivChangePuk(currentPin, newPin, function (resp) {
            if (resp.success) {
                pivSuccessPopup.open()
                views.pop()
            } else {
                pivError.showResponseError(
                    resp,
                    qsTr("PUK change failed for an unknown reason. Error message: %1"),
                    qsTr("PUK change failed for an unknown reason."),
                    {
                        blocked: qsTr("PUK is blocked."),
                        wrong_puk: qsTr("Wrong current PUK. Tries remaning: %1")
                            .arg(resp.tries_left),
                    }
                )

                if (resp.error === 'blocked') {
                    views.pop()
                } else if (resp.error === 'wrong_puk') {
                    clearCurrentPinInput()
                }
            }
        })
    }
}
