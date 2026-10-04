import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtWebEngine 1.10

ApplicationWindow {
    id: root
    visible: true
    width: 430
    height: 860
    color: "#101418"
    title: browser.title || "ABINSTEIN Browser"

    property string addressText: browser.url

    Rectangle {
        anchors.fill: parent
        color: "#101418"

        Rectangle {
            id: toolbar
            height: 64
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
            color: "#1b222b"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 8

                Button {
                    text: "<"
                    enabled: browser.canGoBack
                    onClicked: browser.goBack()
                }

                Button {
                    text: ">"
                    enabled: browser.canGoForward
                    onClicked: browser.goForward()
                }

                Button {
                    text: "⟳"
                    onClicked: browser.reload()
                }

                TextField {
                    id: addressBar
                    Layout.fillWidth: true
                    text: browser.url
                    placeholderText: "Search or enter website"
                    onAccepted: browser.load(text)
                    Keys.onReturnPressed: browser.load(text)
                }

                Button {
                    text: "Go"
                    onClicked: browser.load(addressBar.text)
                }
            }
        }

        ProgressBar {
            id: progressBar
            from: 0
            to: 100
            value: browser.loadProgress
            visible: browser.loadProgress > 0 && browser.loadProgress < 100
            anchors {
                left: parent.left
                right: parent.right
                top: toolbar.bottom
            }
            height: 4
        }

        WebEngineView {
            id: webView
            anchors {
                left: parent.left
                right: parent.right
                top: progressBar.bottom
                bottom: parent.bottom
            }
            url: browser.url
            settings.javascriptEnabled: true
            settings.localStorageEnabled: true
            settings.privateBrowsingEnabled: false

            onTitleChanged: browser.setTitle(title)
            onUrlChanged: browser.setUrl(url)
            onLoadingChanged: {
                if (loadRequest.status === WebEngineLoading::SucceededStatus) {
                    browser.setLoadProgress(100)
                } else if (loadRequest.status === WebEngineLoading::LoadStartedStatus) {
                    browser.setLoadProgress(25)
                    browser.setCanGoBack(webView.canGoBack)
                    browser.setCanGoForward(webView.canGoForward)
                } else if (loadRequest.status === WebEngineLoading::LoadFailedStatus) {
                    browser.setLoadProgress(0)
                }
            }
        }
    }
}
