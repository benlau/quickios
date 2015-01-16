import QtQuick 2.0
import QtTest 1.0
import QuickIOS 0.1

TestCase {
    // Verify the system environment setup
    name : "system"

    // Verify the singleton object
    function test_singleton() {
        compare(QISystem !== undefined,true);
        compare(QIDevice !== undefined,true);
    }

}

