# ActionNav

A navigation manager for Rails applications.

ActionNav allows you to define your navigation centrally and use it throughout your application when required. It handles ensuring that navigation is shown as active when appropriate and hiding navigation items that shouldn't be visible.

## Installation

Install in the usual way.

```ruby
gem "actionnav", "~> 1.0.0"
```

## Getting started

To begin, you need to define a set of navigation items. These can be thought of (and usally will be displayed as) menu items. You can add as many sets as needed by your application. Convention dictates these must be named with a prefix followed by `Navigation`. The best place to put these is in `app/navigation`.

### Defining navigation

Add a file into `app/navigation` called `main_navigation.rb` and add a `MainNavigation` class which lists your navigation items. As usually, be sure to follow the conventions (a `XyzNavigation class has to be defined in a file named `xyz_navigation`).

```ruby
class MainNavigation < ActionNav::Base

  item :dashboard do
    title "Dashboard"
    icon "icons/dashboard.svg"
    url { root_path }
  end

  item :new_post do
    title "Add new post"
    icon "icons/add.svg"
    url { new_post_path }
    hide_unless { current_user.can?("posts.create") }
  end

end
```

That's the most simple, flat, navigation. You can also nest items to create drop down menus if your application demands these...

```ruby
item :settings do
  item :general do
    title "General settings"
    url { general_setings_path }
  end

  item :users do
    title "User management"
    url { users_path }
  end
end
```

When defining an item you have access to the following options:

* `title` - a title for the navigation item. If not provided, ActionNav will present a humanized version of the ID.
* `description` - a description for the navigation item. Optional, you may not need this if your navigation doesn't need it.
* `url` - the URL that the item should point to
* `icon` - a path to an icon to display with the item

All of these items accept a string or a proc. If you provide a proc, it will be evaluated in the context of your ApplicationController so you can access things like `current_user` and any `_path` route methods.

If you provide a proc, ActionNav will ensure this is called appropriate whenever you may need it in a view so you don't need to worry about that.

In addition to these, you can define a `hide_unless` block which allows you to hide navigation items in certain circumstances.

### Outputting your navigation

ActionNav does not care how you actually display its navigation, that's up to you (and your designer). You can do whatever you want. In your views you can access the navigation and ActionNav will pass you useful values. Here's a simple implementation...

```erb
<ul>
  <% navigation[:main].items.each do |item| %>
  <li>
    <%= link_to item.title, item.url, :class => (item.active? ? "is-active" : "is-inactive") %>
  </li>
  <% end %>
</ul>
```

The `navigation[:main]` method allows you to access your navigation and will automatically provide you with items that have computed URLs. If an item has been "hidden" then it will NOT be returned in these methods.

### Activating navigation items

To activate navigation items, you can simply call the following from a controller or a view.

```ruby
navigation[:main].activate :settings, :general
```

You pass a full path to the navigation item that you wish to activate. All parent items will also be marked as active too. You can activate multiple navigation items (if needed) by calling `activate` multiple times.
