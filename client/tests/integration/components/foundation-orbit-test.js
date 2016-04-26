import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('foundation-orbit', 'Integration | Component | foundation orbit', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });"

  this.render(hbs`{{foundation-orbit}}`);

  assert.equal(this.$().text().trim().replace(/\r?\n|\r/g,""), "Previous Slide  Next Slide");

});
