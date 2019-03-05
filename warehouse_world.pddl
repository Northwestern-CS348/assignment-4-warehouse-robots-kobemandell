(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
      :parameters (?r - robot ?i - location ?f - location)
      :precondition (and (connected ?i ?f) (no-robot ?f) (at ?r ?i))
      :effect (and (not (no-robot ?f)) (no-robot ?i) (at ?r ?f) (not (at ?r ?i)))
   )
   
   (:action robotMoveWithPallette
      :parameters (?r - robot ?i - location ?f - location ?p - pallette)
      :precondition (and (connected ?i ?f) (at ?r ?i) (no-robot ?f) (no-pallette ?f) (free ?r) (at ?p ?i))
      :effect (and (not (no-robot ?f)) (no-robot ?i) (at ?r ?f) (not (at ?r ?i)) (at ?p ?f) (no-pallette ?i) (not (no-pallette ?f)) (not (at ?p ?i)) (has ?r ?p))
    )
    
    (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
      :precondition (and (started ?s) (packing-location ?l) (contains ?p ?si) (ships ?s ?o) (orders ?o ?si) (at ?p ?l) (packing-at ?s ?l))
      :effect (and (not (contains ?p ?si)) (includes ?s ?si))
     )
     
    (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (started ?s) (ships ?s ?o) (not (complete ?s)) (packing-at ?s ?l) (packing-location ?l))
      :effect (and (available ?l) (complete ?s) (not (started ?s)) (not (packing-at ?s ?l)))
     )

)
