# Godot_v4.2.2 

### Tipos de nodes para animação:
 - **AnimationPlayer** -> Node usado como filho de um **Sprite2D** Cria na IDE um menu *Animation*, usado para criar animações mais profissionais.

  - **AnimatedSprite2D** -> Usado para criar animações simples. Bastante útil, porem menos poderoso que o AnimationPlayer.

### Funções do godot
- queue_free() -> destrói o objeto. (pode ser inserida no fim de animações para facilitar exclusão de objetos)

- **create_tween()** -> Usado para criar um fade entre duas cores.

Ex de uso:

```
    # Altera a cor do objeto
    modulate = Color.RED

    # Atribui a função a uma variável
	var tween = create_tween()

    # Configura o modo de fade entre as cores
	tween.set_ease(Tween.EASE_IN)

    # Configurar a transição
	tween.set_trans(Tween.TRANS_QUINT)
	
    # Configura qual objeto que terá o fade aplicada e o tempo.
    tween.tween_property(self, "modulate", Color.WHITE, 0.3)

```

### Atributos importantes

 