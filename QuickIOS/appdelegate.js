// Global scope
.pragma library

var sharedDelegate = null;
var application    = null;
var navigationView = null;

function rootView(rootView) {
  application.rootView(rootView);
}

function presentView(view) {
  application.presentView(view)
}

function dismissView() {
  application.dismissView();
}
