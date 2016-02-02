import getParam from "./query_param";

// global (to module) uri
let uri = new URI();

let showTab = function showTab(tabName) {
    $(`.nav.nav-tabs a[href="#${tabName}"]`).tab('show');
}

let tabShown = function tabShown() {
    // if a tab was hidden, calling `.chosen` on its children would render them
    // with a fixed width of 0. so, you have to wait to render chosen selects
    // until they are visible.
    $('.chosen-select:visible').chosen();
};

// html5 history for tabs, save state
let tabLinkClicked = function tabLinkClicked(event) {
    event.preventDefault();
    let el = $(this);

    let tab = el.attr('href').substr(1);
    el.tab('show');

    uri.setSearch('tab', tab);
    window.history.pushState({tab: tab}, '', uri.href());
};

let setCurrentTabState = function setCurrentTabState() {
    let currentTab = uri.query(true).tab;
    if (currentTab) {
        showTab(currentTab);
    } else {
        let activeTabHref = $(`.nav.nav-tabs li.active a[href^="#"]`).attr('href');
        if (activeTabHref) {
            window.history.pushState({tab: activeTabHref.substr(1)}, '');
        }
    }
}

let onPopState = function onPopState({state: state}) {
    if (state.tab) {
        uri.setSearch('tab', state.tab);
        showTab(state.tab);
    }
}

// activate tab panes on page load

;(function main() {
    setCurrentTabState();

    $('.nav.nav-tabs > li > a.grid-tab')
        .on('shown.bs.tab', tabShown)
        .on('click', tabLinkClicked);

    //handle html5 back
    window.onpopstate = onPopState;
})();
