export type TrackingEvent = {
  status: string; location: string; description: string; event_time: string;
};
export type Shipment = {
  tracking_number: string; status: string; origin: string; destination: string;
  estimated_delivery: string | null; events: TrackingEvent[];
};

// Starter integration only. Production public tracking should use a rate-limited server API.
export async function getShipment(trackingNumber: string): Promise<Shipment | null> {
  const { supabase } = await import("./supabase");
  if (!supabase) return null;
  const { data: shipment, error } = await supabase.from("shipments")
    .select("id, tracking_number, status, origin, destination, estimated_delivery")
    .eq("tracking_number", trackingNumber.trim().toUpperCase()).maybeSingle();
  if (error || !shipment) return null;
  const { data: events } = await supabase.from("tracking_events")
    .select("status, location, description, event_time").eq("shipment_id", shipment.id)
    .order("event_time", { ascending: false });
  return { ...shipment, events: events ?? [] };
}
