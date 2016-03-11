import Ember from 'ember';

const {Mixin, isArray} = Ember;

export const RouterTitleMixin = Mixin.create({
  didTransition () {
    this._super(...arguments);
    this.send('collectTitleTokens', []);
  },

  setTitle (title) {
    window.document.title = title;
  }
});

export default Mixin.create({
  // `titleToken` can either be a static string or a function
  // that accepts a model object and returns a string (or array
  // of strings if there are multiple tokens).
  titleToken: null,

  // `title` can either be a static string or a function
  // that accepts an array of tokens and returns a string
  // that will be the document title. The `collectTitleTokens` action
  // stops bubbling once a route is encountered that has a `title`
  // defined.
  title: null,

  actions: {
    collectTitleTokens(tokens) {
      let titleToken = this.get('titleToken');
      let finalTitle;

      if (typeof titleToken === 'function') {
        titleToken = this.titleToken(this.currentModel);
      }

      if (isArray(titleToken)) {
        tokens.push(...titleToken);
      } else if (titleToken) {
        tokens.push(titleToken);
      }

      if (this.title) {
        if (typeof this.title === 'function') {
          finalTitle = this.title(tokens);
        } else {
          finalTitle = this.title;
        }

        this.router.setTitle(finalTitle);
      } else {
        return true;
      }
    }
  }
});
