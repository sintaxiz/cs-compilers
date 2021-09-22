class Stack {

   isNil() : Bool { true };
   
   head()  : Command { { abort(); new Command; } };

   tail()  : Stack { { abort(); self; } };

   cons(i : Command) : Stack {
      (new Cons).init(i, self)
   };
};

class Cons inherits Stack {

   cmd : Command;

   stack : Stack;

   isNil() : Bool { false };

   head()  : Command { cmd };

   tail()  : Stack { stack };

   init(i : Command, rest : Stack) : Stack {
      {
	 cmd <- i;
	 stack <- rest;
	 self;
      }
   };

};


class Command {
    execute(stack : Stack): Stack {
        {abort(); new Stack; }
    };
    toString() : String {
       ""
    };
};

class GetInteger inherits Command {
    value : Int;
    setValue(newValue : Int) : Command { {
       value <- newValue;
       self;
    }
    };
    getValue() : Int { 
       value
    };
    execute(stack : Stack): Stack {stack};
    toString() : String {
       (new A2I).i2a(value)
    };
};


class Plus inherits Command {
    execute(stack : Stack): Stack { 
       if (stack.isNil()) then stack 
       else 
          (let x : Int <- case stack.head() of
            a : GetInteger => a.getValue();
            b : Object => 0;
         esac in
         (let y : Int <- case stack.tail().head() of
            c : GetInteger => c.getValue();
            d : Object => 0;
         esac in 
         stack.tail().tail().cons(new GetInteger.setValue(x + y))
         ) )

       fi
    }; 

    toString() : String {
       "+"
    };
};

class Swap inherits Command {
     execute(stack : Stack): Stack { 
         stack.tail().tail().cons(stack.head()).cons(stack.tail().head())
    }; 

    
    toString() : String {
       "s"
    };
};


class Main inherits IO {
    command : Command;
    stack : Stack;
    inCommand : String;
    isNotStop : Bool;


   printStack(s : Stack) : Object {
         if s.isNil() then out_string("\n")
                   else {
			   out_string(s.head().toString());
			   out_string(" ");
			   printStack(s.tail());
		        }
         fi

   };

    main() : Object {
        {
         stack <- new Stack;
         isNotStop <- true;
        while (isNotStop) loop  {
            out_string(">");
            inCommand <- in_string();
            if (inCommand = "+") then {
               stack <- stack.cons(new Plus);
            }
             else if (inCommand = "s") then {
               stack <- stack.cons(new Swap);
            } 
            else if (inCommand = "e") then {
               command <- stack.head();
               stack <- stack.tail();
               stack <- command.execute(stack);
            } 
            else if (inCommand = "d") then {
               printStack(stack);
            } 
            else if (inCommand = "x") then {
               isNotStop <- false;
            } 
             else  {
               stack <- stack.cons(new GetInteger.setValue((new A2I).a2i(inCommand)));
            } fi fi fi fi fi;
        } pool;
        }
    };
};