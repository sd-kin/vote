App.notifications = App.cable.subscriptions.create("NotificationsChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
    this.set_current_user();
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    $('#notifications').append(data.notification);
  },

  set_current_user: function() {
    return this.perform('create_current_user_stream', {user_id: $('meta[name=current_user]').attr('id')});
  }
});
