{BufferedProcess, CompositeDisposable} = require 'atom'
path = require 'path'

module.exports =
class RubocopAutoCorrect
  constructor: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'rubocop-auto-correct:current-file': =>
        if editor = atom.workspace.getActiveTextEditor()
          @run(editor)

  destroy: ->
    @subscriptions.dispose()

  autoCorrect: (filePath)  ->
    basename = path.basename(filePath)
    command = atom.config.get('rubocop-auto-correct.rubocopCommandPath')
    args = ['-a', filePath]
    exit = (code) ->
       if (code == 0)
         atom.notifications.addSuccess("#{command} -a #{basename}")
       else
         atom.notifications.addError("Failer #{command} -a #{basename}")
    process = new BufferedProcess({command, args, exit})
    process

  run: (editor) ->
    if editor.isModified()
      editor.save()
    @autoCorrect(editor.getPath())
