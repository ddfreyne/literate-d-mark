# Literate D★Mark: an experiment

To run:

```
% ruby literate-dmark.rb day-9.dmark
```

This will generate _day-9-lit.html_ and _day-9-lit.rb_ from _day-9.dmark_.

## Automatic approach

With a tool like [guard](https://github.com/guard/guard) or [filewatcher](https://github.com/thomasfl/filewatcher), you can generate the resulting files automatically when the source file changes. When combined with a too like [LivePage](https://github.com/MikeRogers0/LivePage), you can be writing D★Mark and have the resulting HTML file be updated in real-time, _and_ run the resulting Ruby file at the same time.

```
% filewatcher *.dmark 'ruby literate-dmark.rb $FILENAME'
% filewatcher *-lit.rb 'ruby $FILENAME'
```

## Limitations

This is an experiment, and the HTML that is generated doesn’t have the proper boilerplate, and also has only very basic styling.
