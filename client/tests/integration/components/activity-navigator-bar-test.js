import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('activity-navigator-bar', 'Integration | Component | activity navigator bar', {
  integration: true
});

test('it renders', function(assert) {
  this.setProperties({
    activity: {
      name: 'act name'
    }
  });
  this.render(hbs`{{activity-navigator-bar activity=activity}}`);

  assert.equal(this.$('.select-activity p').text().trim(), 'Activity:');
  assert.equal(this.$('.current').text().trim(), 'act name');
});
