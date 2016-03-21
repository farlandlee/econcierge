import Ember from 'ember';
import ResetScrollMixin from 'client/mixins/reset-scroll';
import RouteTitleMixin from 'client/mixins/route-title';

export default Ember.Route.extend(ResetScrollMixin, RouteTitleMixin, {
  titleToken: 'Error 404'
});
